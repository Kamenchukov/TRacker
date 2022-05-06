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
    
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var marker: GMSMarker?
    var geoCoder:CLGeocoder?
    var route: GMSPolyline?
    var locationManager: CLLocationManager?
    var routePath: GMSMutablePath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
//        locationManager?.allowsBackgroundLocationUpdates = true
    }
    private func addMarker() {
        marker = GMSMarker(position: coordinate)
        marker?.map = mapView
    }
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
    }
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    @IBAction func didTapUpdateLocation(_ sender: UIButton) {
        locationManager?.requestLocation()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        locationManager?.startUpdatingLocation()
    }
    @IBAction func addMarkerDidTap(_ sender: UIButton) {
        if marker == nil {
           mapView.animate(toLocation: coordinate)
            addMarker()
        } else {
            removeMarker()
        }
    }
    
}
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        let manualMarker = GMSMarker(position: coordinate)
        manualMarker.map = mapView
        
        if geoCoder == nil {
        geoCoder = CLGeocoder()
        }
        
        geoCoder?.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { places, error in
            print(places?.last)
        })
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        routePath?.add(location.coordinate)
        route?.path = routePath

        let position = GMSCameraPosition.camera(withTarget: location.coordinate , zoom: 15)
        mapView.animate(to: position)

        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
