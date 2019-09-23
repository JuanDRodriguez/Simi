//
//  LocationDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol LocationProtocol: class {
    func locationNotAllowed()
    func locationAllowed()
    func updateLocation(newLocation: CLLocation)
}

//public let kCLLocationAccuracyBestForNavigation: CLLocationAccuracy
//public let kCLLocationAccuracyBest: CLLocationAccuracy
//public let kCLLocationAccuracyNearestTenMeters: CLLocationAccuracy
//public let kCLLocationAccuracyHundredMeters: CLLocationAccuracy
//public let kCLLocationAccuracyKilometer: CLLocationAccuracy
//public let kCLLocationAccuracyThreeKilometers: CLLocationAccuracy

class LocalizationDelegate: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    weak var delegate : LocationProtocol?
    
    override init(){
        super.init()
        self.locationManager.delegate = self
    }
    
    func authStatus(_ status : CLAuthorizationStatus){
        switch status {
        case .restricted, .denied:
            self.delegate?.locationNotAllowed()
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.delegate?.locationAllowed()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        CommonData.setCurrentLocation(location: location)
        self.delegate?.updateLocation(newLocation: location)
    }
        
    func stopUpdateLocation(){
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
    }
}
