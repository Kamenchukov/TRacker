//
//  LocationManager.swift
//  TRacker
//
//  Created by Константин Каменчуков on 25.05.2022.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationManager: NSObject {
    
    let autorizationStatus: BehaviorSubject<CLAuthorizationStatus>
    let userLocation = PublishSubject<CLLocation>()
    
    private let locationManager = CLLocationManager()
    

    override init() {
        self.autorizationStatus = BehaviorSubject(value: locationManager.authorizationStatus)
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func requestAutorizationAccess() {
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        autorizationStatus.onNext(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation.onNext(location)
        }
    }
}
