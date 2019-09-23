//
//  NativeMapView.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import MapKit

enum ShowingLines {
    case none
    case lines
    case polygons
}

class NativeMapView: UIView, MapsProtocol {
    @IBOutlet var componentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    weak var delegate: MapViewProtocol?
    var task : DispatchWorkItem?
    let images: [Int: String] = [UnitsType.branchOffice.rawValue: "sucursal",
                                 UnitsType.franchise.rawValue: "franquicia",
                                 UnitsType.lab.rawValue: "laboratorio"]
    let colors: [Int: UIColor] = [1: UIColor(red: 91.0 / 255.0, green: 151.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0),
                                  2: UIColor(red: 135.0 / 255.0, green: 194.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0),
                                  3: UIColor(red: 238.0 / 255.0, green: 200.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)]
    let overlayRender = MKOverlayRenderer()
    var overlinesShowing : ShowingLines = .none
    var showingBlocks = false
    var currentZoom : Float = 1.0
    var polygonSelected : MKPolygon?
    var polygons : [MKPolygon] = []
    var polylines : [MKPolyline] = []
    var currentLocation : CLLocation?
    var polylinesRoutes : [MKPolyline] = []
    var annotations : [UnitAnnotation] = []
    var placesToPut : [[String : Any]] = []
    let annotationCloseTo = MKPointAnnotation()
    var annotationIsInMap = false
    var suportAnnotations : [UnitAnnotation] = []
    var addingAnnotations = false
    var currentAnnotation = 0
//    var canceled = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(nameView: "NativeMapView", owner: self)
        mapView.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(nameView: "NativeMapView", owner: self)
        mapView.delegate = self
    }
    func setCurrentLocation (location: CLLocation) {
        self.currentLocation = location
    }
    func centerUser() {
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    func activeDeactiveCompass() {
        self.mapView.userTrackingMode = self.mapView.userTrackingMode == .followWithHeading ? .follow : .followWithHeading
    }
    
    func putAnnotations(places :  [[String : Any]], supportedAnnotations: Bool) {
//        self.canceled = true
        self.placesToPut = places
        self.task?.cancel()
        if supportedAnnotations {
            self.mapView.removeAnnotations(self.suportAnnotations)
        } else {
            self.mapView.removeAnnotations(self.annotations)
        }
        if placesToPut.count > 0 {
            self.currentAnnotation = 0
            self.addingAnnotations = true
            self.addSectionAnnotation(supported: supportedAnnotations)
        }
    }
    
    func addSectionAnnotation(supported: Bool) {
        var temporalAnnotations : [UnitAnnotation] = []
        let limit = self.currentAnnotation + 50 > self.placesToPut.count ? self.placesToPut.count : self.currentAnnotation + 50
        
        if self.currentAnnotation < self.placesToPut.count {
            self.task = DispatchWorkItem {
                self.addSectionAnnotation(supported: supported)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: task!)
        }
        
        for i in (self.currentAnnotation..<limit) {
            let unit = self.placesToPut[i]
            if  let lat = unit[KeysUnit.lat.rawValue] as? Double,
                let lng = unit[KeysUnit.lng.rawValue] as? Double {
                let annotation = UnitAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                annotation.unit = unit
                temporalAnnotations.append(annotation)
                self.mapView.addAnnotation(annotation)
            }
        }
        if supported {
            self.suportAnnotations += temporalAnnotations
        } else {
            self.annotations += temporalAnnotations
        }
        if self.addingAnnotations {
            self.addingAnnotations = false
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        self.currentAnnotation = limit
    }
    
    func showBricks(blocks : [[String: Any]]){
        if self.polygons.count == 0 && self.polylines.count == 0 {
            for block in blocks{
                guard let arrayCoordinates = block[KeysBrick.arrayCoordinates.rawValue] as? [CLLocationCoordinate2D] else { return }
                let name: String = block[KeysBrick.name.rawValue] as! String
                let totalMarket: String = block[KeysBrick.totalMarket.rawValue] as! String
                let town: String = block[KeysBrick.town.rawValue] as! String
                
                let polygon = MKPolygon(coordinates: arrayCoordinates, count: arrayCoordinates.count)
                polygon.title = "\( name)  \( totalMarket))\( town)"
                polygon.color = block[KeysBrick.color.rawValue] as! UIColor
                polygon.block = block
                let render = MKPolygonRenderer(polygon: polygon)
                polygon.render = render
                polygon.render!.strokeColor = strokeNormalColor
                polygon.render!.fillColor = polygon.color
                polygon.render!.lineWidth = 1
                self.polygons.append(polygon)
                
                let polyline = MKPolyline(coordinates: arrayCoordinates, count: arrayCoordinates.count)
                polyline.color = polygon.color
                let renderLine = MKPolylineRenderer(polyline: polyline)
                polyline.render = renderLine
                polyline.render!.strokeColor = strokeNormalColor
                polyline.render!.lineWidth = strokeNormalWidth
                self.polylines.append(polyline)
            }
        }
        self.showingBlocks = true
        let zoomWidth = self.mapView.visibleMapRect.size.width
        let zoomFactor = Float((log2(zoomWidth)) - 9.0)
        updateOverlaysInMap(zoom: zoomFactor)
    }
    func removeBricks() {
        self.mapView.removeOverlays(self.polylines)
        self.mapView.removeOverlays(self.polygons)
        self.polygonSelected?.render!.strokeColor = strokeNormalColor
        self.polygonSelected?.render!.lineWidth = strokeNormalWidth
        self.showingBlocks = false
        self.polygonSelected = nil
        self.currentZoom = 1.0
    }
    func touchesInMap(touchLocation : CGPoint) {
        let locationCoordinate = self.mapView.convert(touchLocation, toCoordinateFrom: self.mapView)
        for polygon in polygons {
            let renderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint = MKMapPoint(locationCoordinate)
            let viewPoint = renderer.point(for: mapPoint)
            if renderer.path.contains(viewPoint) {
                guard let block = renderer.polygon.block else { return }
                
                if let polygonSelected = polygonSelected{
                    polygonSelected.render!.strokeColor = strokeNormalColor
                    polygonSelected.render!.lineWidth = strokeNormalWidth
                    polygonSelected.render!.setNeedsDisplay()
                }
                polygonSelected = polygon
                self.delegate?.showBrickInfo(block: block)
                guard let latLng = block[KeysBrick.centerBlock.rawValue] as? (Double, Double) else { return }
                let normalizedZoom : Double = abs(Double(currentZoom - 10.0))
                let lat: CLLocationDegrees = latLng.0 - (0.05 / normalizedZoom)
                let lng: CLLocationDegrees = latLng.1
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                polygon.render!.strokeColor = strokeSelectedColor
                polygon.render!.lineWidth = strokeSelectedWidth
                polygon.render!.setNeedsDisplay()
                mapView.setCenter(coordinate, animated: true)
            }
        }
    }
    func insertInMap(array:[MKOverlay], start : Int, end : Int) {
        let trueEnd = end < array.count ? end : (array.count - 1)
        DispatchQueue.main.async { [weak self] in
            if start < trueEnd {
                for i in start...trueEnd {
                    let overlay = array[i]
                    self!.mapView.addOverlay(overlay)
                }
            }
        }
        if trueEnd < array.count - 1 && self.showingBlocks {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
                self!.insertInMap(array: array, start: trueEnd + 1, end: trueEnd + 100)
            })
        } else {
            self.delegate?.bricksEnabled(enabled: true)
            mapView.isZoomEnabled = true
        }
    }
    func updateOverlaysInMap(zoom : Float) {
        if self.showingBlocks {
            let zoomToPolygon : Float = 9.0
            if zoom < zoomToPolygon && (currentZoom >= zoomToPolygon || currentZoom == 1.0) {//APARECEN POLYGONOS, BORRAR LINEAS
                DispatchQueue.main.async { [weak self] in
                    self!.mapView.removeOverlays(self!.polylines)
                }
                mapView.isZoomEnabled = false
                self.delegate?.bricksEnabled(enabled: false)
                insertInMap(array: polygons, start: 0, end: 100)
            }
            if zoom > zoomToPolygon && (currentZoom <= zoomToPolygon || currentZoom == 1.0) {//APARECEN LINEAS, BORRAR POLIGONOS
                self.delegate?.showBrickInfo(block: nil)
                DispatchQueue.main.async {[weak self] in
                    self!.mapView.removeOverlays(self!.polygons)
                }
                mapView.isZoomEnabled = false
                self.delegate?.bricksEnabled(enabled: false)
                insertInMap(array: polylines, start: 0, end: 30)
            }
            currentZoom = zoom
        }
    }
    func addAnnotationTap(gesture : UILongPressGestureRecognizer) {
        let location = gesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: self.mapView)
        self.annotationCloseTo.coordinate = coordinate
        self.delegate?.searchUnitsClose(location: coordinate)
        if !annotationIsInMap {
            mapView.addAnnotation(self.annotationCloseTo)
        }
    }
    func removeCloseAnnotation() {
        mapView.removeAnnotation(self.annotationCloseTo)
    }
}
