//
//  MapsProtocol.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol MapViewProtocol: class {
    func showBrickInfo(block: [String: Any]?)
    func bricksEnabled(enabled: Bool)
    func selectUnit(unit: [String: Any]?)
    func hideKeyboard()
    func compassUpdate(active: Bool)
    func showQr(showed: Bool)
    func searchUnitsClose(location: CLLocationCoordinate2D)
}

protocol MapsProtocol {
    var delegate: MapViewProtocol? {get set}
    var componentView : UIView! { get }
    var strokeNormalColor : UIColor { get }
    var strokeSelectedColor : UIColor { get }
    var strokeNormalWidth : CGFloat { get }
    var strokeSelectedWidth : CGFloat { get }
    func touchesInMap(touchLocation : CGPoint)
    func centerUser()
    func activeDeactiveCompass()
    func setCurrentLocation (location: CLLocation)
    func commonInit (nameView : String, owner : UIView)
    func showBricks(blocks : [[String: Any]])
    func removeBricks()
    func addAnnotationTap(gesture : UILongPressGestureRecognizer)
    func putAnnotations(places : [[String : Any]], supportedAnnotations: Bool)
    func removeCloseAnnotation()
}

extension MapsProtocol {
    var strokeNormalColor : UIColor { get { return .magenta } }
    var strokeSelectedColor : UIColor { get { return .red } }
    var strokeNormalWidth : CGFloat { get { return 1.0 } }
    var strokeSelectedWidth : CGFloat { get { return 3.0 } }
    
    func commonInit (nameView : String, owner : UIView){
        Bundle.main.loadNibNamed(nameView, owner: owner)
        owner.addSubview(componentView)
        componentView.frame = owner.frame
        componentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
//    func getCoordinateValue(coordinate : Coordinates) -> Double{
//        switch coordinate {
//        case .double(let double): return double
//        }
//    }
    func touchesInMap(touchLocation : CGPoint){}
    
}
