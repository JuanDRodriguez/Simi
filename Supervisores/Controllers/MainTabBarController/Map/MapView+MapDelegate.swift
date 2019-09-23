//
//  MapView+MapDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 26/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MapViewProtocol {
    func showBrickInfo(block: [String: Any]?){
        if let infoBlock = block {
            if self.bricksShowed && !self.locked {
                self.infoBricks?.setInfornation(infoBlock: infoBlock)
                self.infoUnit?.isHidden = true
                self.driveOptions?.isHidden = true
            }
        } else {
            self.infoBricks?.isHidden = true
        }
    }
    func bricksEnabled(enabled: Bool){
        self.btnShowHideBricks.isEnabled = enabled
    }
    func selectUnit(unit: [String: Any]?){
        guard let unitShow = unit else {
            self.btnDriveOptions.isHidden = true
            self.infoUnit?.isHidden = true
            self.fromDestination = nil
            return
        }
        if let lat = unitShow[KeysUnit.lat.rawValue] as? Double,
            let lng = unitShow[KeysUnit.lng.rawValue] as? Double {
            self.fromDestination = CLLocation(latitude: lat, longitude: lng)
            self.btnDriveOptions.isHidden = false
        }
        
        self.lock()
        guard let unitId = unitShow[KeysUnit.idUnit.rawValue] as? Int else { return }
        guard let unitContact = unitShow[KeysUnit.contact.rawValue] as? String else { return }
        guard let unitKey = unitShow[KeysUnit.key.rawValue] as? String else { return }
        guard let unitName = unitShow[KeysUnit.name.rawValue] as? String else { return }
        UnitInfoViewModel.shared.getUnitInfo(unitId: unitId, contactName: unitContact, keyUnit: unitKey, nameUnit: unitName)
        self.searchBarVC?.searchBar.text = ""
    }
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    func compassUpdate(active: Bool){
        let imageName = active ? "compass-active": "compass-inactive"
        self.btnCompass.setImage(UIImage(named: imageName), for: .normal)
    }
    @objc func showQr(showed: Bool){
        self.viewQR.isHidden = false
    }
    func searchUnitsClose(location: CLLocationCoordinate2D) {
        self.gestureLottie.isHidden  = true
        self.stackButtonsDistance.isHidden = false
        let stringRatio = String(format: "%.02f", self.currentRatio)
        self.lblLoading.isHidden = false
        self.lblLoading.text = "Radio: \(stringRatio)km"
        self.locationClose = location
        if !UnitsMapViewModel.shared.searchUnits(searchBy: "", searchFilter: self.searchingFilter, location: location, ratio: self.currentRatio){
            self.lblLoading.text = titleSearch
            self.lblLoading.isHidden = false
        }
    }
}
