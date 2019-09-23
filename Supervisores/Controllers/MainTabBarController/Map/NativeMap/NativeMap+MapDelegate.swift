//
//  Map+MapDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import MapKit

extension NativeMapView: MKMapViewDelegate {
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0]
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began ||
                    recognizer.state == UIGestureRecognizer.State.changed ||
                    recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Float((log2(zoomWidth)) - 9.0)
        updateOverlaysInMap(zoom: zoomFactor)
        if self.mapViewRegionDidChangeFromUserInteraction(){
            self.delegate?.hideKeyboard()
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        if let pointAnnotation = annotation as? MKPointAnnotation {
            if pointAnnotation == self.annotationCloseTo {                
                let annotationIdentifier = "closeTo"
                var annotationView: MKAnnotationView?
                if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                    annotationView = dequeuedAnnotationView
                }
                else {
                    let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                    annotationView = av
                }
                annotationView?.image = UIImage(named: "closeTo.png")
                annotationView?.annotation = annotation
                guard let annotationV = annotationView else { return nil}
                return annotationV
            }
        }
    
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let label = UILabel(frame: CGRect(x: -25, y: -30, width: 86, height: 30))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.font = label.font.bold()
            label.font = label.font.withSize(12.0)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.tag = 1
            av.addSubview(label)
            annotationView = av
        }
        annotationView?.annotation = annotation
        guard let unitAnnotation = annotation as? UnitAnnotation else { return nil }
        guard let annotationV = annotationView else { return nil }
        guard let unit = unitAnnotation.unit else { return nil }
       
        if  let typeUnit = unit[KeysUnit.typeUnit.rawValue] as? Int,
            let image = self.images[typeUnit] {
            annotationV.image = UIImage(named: image)
            TypeUnit.typeUnit = typeUnit
        }
        
        if let foundBy = unit[KeysUnit.foundBy.rawValue] as? String {
            let label = annotationV.viewWithTag(1) as! UILabel
            if foundBy != "" {
                label.isHidden = false
                label.text = foundBy
                if  let type = unit[KeysUnit.typeUnit.rawValue] as? Int,
                    let color = self.colors[type] {
                    label.backgroundColor = color
                }
            } else {
                label.isHidden = true
            }
        }
        return annotationV
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? UnitAnnotation else { return }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.annotations.removeAll()
        self.annotations.append(annotation)
        self.mapView.addAnnotations(self.annotations)
        self.delegate?.selectUnit(unit: annotation.unit)
        self.mapView.setCenter(annotation.coordinate , animated: true)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.delegate?.selectUnit(unit: nil)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            if let render = (overlay as! MKPolygon).render{
                return render
            }
        }
        if overlay is MKPolyline{
            if let render = (overlay as! MKPolyline).render{
                return render
            }
        }
        return overlayRender
    }
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        self.delegate?.compassUpdate(active: mode == .followWithHeading)
    }
}
