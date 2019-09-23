//
//  NativeMapExtensions.swift
//  Supervisores
//
//  Created by Sharepoint on 11/10/18.
//  Copyright © 2018 Sharepoint. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> Double {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
extension MKPolygon {
    weak var render : MKPolygonRenderer? {
        get {
            guard let value = objc_getAssociatedObject(self, &ExtensionsMap.renderAttached) as? MKPolygonRenderer else {
                return MKPolygonRenderer(polygon: self)
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ExtensionsMap.renderAttached, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let renderer = MKPolygonRenderer(polygon: self)
        let mapPoint = MKMapPoint(coordinate)
        let viewPoint = renderer.point(for: mapPoint)
        return renderer.path.contains(viewPoint)
    }
}
struct ExtensionsMap {
    static var color : String = "color"
    static var renderAttached : String = "renderAttached"
    static var block : String = "block"
}
extension MKOverlay {
    var color: UIColor {
        get {
            guard let value = objc_getAssociatedObject(self, &ExtensionsMap.color) as? UIColor else {
                return UIColor.white
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ExtensionsMap.color, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var block: [String: Any]?{
        get {
            guard let value = objc_getAssociatedObject(self, &ExtensionsMap.block) as? [String: Any] else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ExtensionsMap.block, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
extension MKPolyline{
    weak var render : MKPolylineRenderer? {
        get {
            guard let value = objc_getAssociatedObject(self, &ExtensionsMap.renderAttached) as? MKPolylineRenderer else {
                return MKPolylineRenderer(polyline: self)
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ExtensionsMap.renderAttached, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
