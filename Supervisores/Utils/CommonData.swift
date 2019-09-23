//
//  CommonData.swift
//  Supervisores
//
//  Created by Sharepoint on 12/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import MapKit

class CommonData {
    static private var currentLocation : CLLocation?
    static func setCurrentLocation(location: CLLocation){
        currentLocation = location
    }
    static func getCurrentLocation()->CLLocation?{
        return currentLocation
    }
}
struct TypeUnit {
    static var typeUnit = 1
}
