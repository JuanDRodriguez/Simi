//
//  CustomAnnotation.swift
//  Supervisores
//
//  Created by Sharepoint on 29/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import MapKit

class UnitAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var unit: [String: Any]?
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
