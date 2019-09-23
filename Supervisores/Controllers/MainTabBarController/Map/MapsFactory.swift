//
//  MapsFactory.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

enum NavigationMaps{
    case nativeMap
//    case googleMap
}

class MapsFactory : NSObject{
    let frameMap : CGRect
    init(frame : CGRect) {
        frameMap = frame
        super.init()
    }
    
    func buildMap(mapType : NavigationMaps) -> MapsProtocol {
        switch mapType {
        case .nativeMap:
            return NativeMapView(frame: frameMap)
//        case .googleMap:
//            return GoogleMapView(frame: frameMap)
        }
    }
}
