//
//  Location.swift
//  TRacker
//
//  Created by Константин Каменчуков on 12.05.2022.
//

import Foundation
import CoreLocation
import RealmSwift

class Location: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        
        self.latitude = latitude
        self.longitude = longitude
    }
}
