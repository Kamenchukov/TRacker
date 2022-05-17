//
//  MapViewController.swift
//  TRacker
//
//  Created by Константин Каменчуков on 05.05.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var trackPositionButton: UIBarButtonItem!
    @IBOutlet weak var lastTrackingButton: UIBarButtonItem!
    
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var marker: GMSMarker?
    var geoCoder:CLGeocoder?
    var route: GMSPolyline?
    var locationManager: CLLocationManager?
    var routePath: GMSMutablePath?
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier?
    private var isTrackingPosition = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    
    private func checkLocationStatus() {
        let locationStatus = locationManager?.authorizationStatus
        switch locationStatus {
        
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
        case .restricted, .denied:
            print("Location access denied")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    private func setupRoute() {
        route?.strokeWidth = 5
        route?.map = mapView
    }
    
    private func configureBackground() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = .invalid
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            print(Date())
            
        }
    }
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestAlwaysAuthorization()
    }
    private func addMarker(at coordinate: CLLocationCoordinate2D) {
        marker = GMSMarker(position: coordinate)
        marker?.map = mapView
    }
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        if let style = Bundle.main.url(forResource: "style", withExtension: "json"){
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: style)
        }
        
    }
    private func removeMarker(_ marker: GMSMarker) {
        marker.map = nil
    }
    private func resetRouteLine() {
        route?.map = nil
        routePath = GMSMutablePath()
        route = GMSPolyline(path: routePath)
        setupRoute()
    }
    private func saveRoute() {
        guard let path = route?.path else { return }
        
        var coordinates = [Location]()
        for index in 0..<path.count() {
            let coordinate = path.coordinate(at: index)
            let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
            coordinates.append(location)
        }
        
        RouteStorage.shared.saveLastRoute(route: coordinates)
    }
    @objc private func showLastRoute() {
        if isTrackingPosition {
            let yesAction = UIAlertAction(title: "Start tracking", style: .default) { [weak self] _ in
                self?.handleTracking()
                self?.loadLastRoute()
            }
            let noAction = UIAlertAction(title: "Stop tracking", style: .cancel)
            showAlert(with: "No",
                      message: "Do you want to stop tracking?",
                      actions: [noAction, yesAction]
            )
        } else {
            loadLastRoute()
        }
    }
    func loadLastRoute() {
        let locations = RouteStorage.shared.loadLastRoute()
        
        resetRouteLine()
        for location in locations {
            addMarker(at: location.coordinate)
        }
    }
    
    @objc private func handleTracking() {
        checkLocationStatus()
    }
    @IBAction func didTapUpdateLocation(_ sender: UIButton) {
        locationManager?.requestLocation()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction func trackButtonAction(_ sender: Any) {
        checkLocationStatus()
        isTrackingPosition.toggle()

        trackPositionButton.title = isTrackingPosition ? "Stop tracking" : "Start tracking"
       // trackPositionButton.title = isTrackingPosition ? "Stop tracking" : "Start tracking"
        if isTrackingPosition {
            locationManager?.startUpdatingLocation()
            locationManager?.startMonitoringSignificantLocationChanges()
            setupRoute()
            resetRouteLine()
        } else {
            locationManager?.stopUpdatingLocation()
            locationManager?.stopMonitoringSignificantLocationChanges()
            saveRoute()
        }
    }
    @IBAction func lastTrackingButtonAction(_ sender: Any) {
        showLastRoute()
    }
    
}
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        removeMarker(marker)
        return false
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        addMarker(at: coordinate)
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        checkLocationStatus()
        return true
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationStatus()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let position = GMSCameraPosition(target: location.coordinate, zoom: 17)
            mapView.animate(to: position)
            routePath?.add(location.coordinate)
            route?.path = routePath
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
