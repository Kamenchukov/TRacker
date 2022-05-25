//
//  MapViewController.swift
//  TRacker
//
//  Created by Константин Каменчуков on 05.05.2022.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var trackPositionButton: UIBarButtonItem!
    @IBOutlet weak var lastTrackingButton: UIBarButtonItem!
    
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var marker: GMSMarker?
    var geoCoder:CLGeocoder?
    var route: GMSPolyline?
    var locationManager = LocationManager()
    var routePath: GMSMutablePath?
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier?
    private var isTrackingPosition = false
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    
    private func setupLocationManager() {
             locationManager.autorizationStatus.subscribe(onNext: { status in
                 print("Location status \(status)")
             })
             .disposed(by: disposeBag)
        locationManager.userLocation.subscribe(onNext: { [weak self] location in
                     self?.updateUserLocation(location)
                 })
                 .disposed(by: disposeBag)
             }
    func updateUserLocation(_ location: CLLocation) {
        let position = GMSCameraPosition(target: location.coordinate, zoom: 17)
        mapView.animate(to: position)
        routePath?.add(location.coordinate)
        route?.path = routePath
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
        locationManager.autorizationStatus.subscribe(onNext: { status in
            print("Location status \(status)")
        })
        .disposed(by: disposeBag)
        
        locationManager.userLocation.subscribe(onNext: { [weak self] location in
            self?.updateUserLocation(location)
        })
        .disposed(by: disposeBag)
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
        
    }
    @IBAction func didTapUpdateLocation(_ sender: UIButton) {
        let marker = GMSMarker(position: mapView.camera.target)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
    }
    
    @IBAction func trackButtonAction(_ sender: Any) {
        isTrackingPosition.toggle()
        trackPositionButton.title = isTrackingPosition ? "Stop tracking" : "Start tracking"
        if isTrackingPosition {
            locationManager.startUpdateLocation()
            setupRoute()
            resetRouteLine()
        } else {
            locationManager.stopUpdateLocation()
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
        locationManager.requestAutorizationAccess()
        return true
    }
}

