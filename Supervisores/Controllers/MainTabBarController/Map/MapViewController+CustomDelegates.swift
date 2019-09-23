//
//  Map+CustomDelegates.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreLocation

extension MapViewController: LocationProtocol, BricksVMProtocol, SearchingProtocol, UnitsMapVMProtocol, PickerSelectViewDelegate, UnitInfoVMProtocol {
    //MARK: LOCATION PROTOCOL
    func locationNotAllowed() {
        self.appPermissionView = AppPermissions(frame: self.view.frame, permision: Permissions.location)
        guard let permission = self.appPermissionView else {
            return
        }
        self.view.addSubview(permission)
        self.view.bringSubviewToFront(permission)
    }
    func locationAllowed(){
        guard let permission = self.appPermissionView else {
            return
        }
        permission.removeFromSuperview()
        self.appPermissionView = nil
    }
    func updateLocation(newLocation: CLLocation) {
        self.currentPosition = newLocation
        self.mapViewSelected?.setCurrentLocation(location: newLocation)
    }
    //MARK: BRCIKS PROTOCOL
    func bricksLoaded(bricks: [[String: Any]]) {
        DispatchQueue.main.async { [weak self] in
            self!.btnShowHideBricks.isEnabled = true
            self!.arrayBricks = bricks
        }
    }
    //MARK: SEARCH PROTOCOL
    func typingSearch(text: String) {
        self.searchingBy = text
        self.typing = true
        self.task?.cancel()
        self.task = DispatchWorkItem {
            if !UnitsMapViewModel.shared.searchUnits(searchBy: self.searchingBy, searchFilter: self.searchingFilter, location: nil, ratio: self.currentRatio) {
                if self.searchingBy.count >= 3 {
                    self.lblLoading.text = self.titleSearch
                    self.lblLoading.isHidden = false
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task!)
    }
    //MARK: UNITS VM
    func unitsSearched(units: [[String: Any]]) {
        DispatchQueue.main.async {
            let trueUnits = units.filter({unit in
                guard let lat = unit[KeysUnit.lat.rawValue] as? Double else {return false}
                guard let lng = unit[KeysUnit.lng.rawValue] as? Double else {return false}
                return lat != 0.0 && lng != 0.0
            })
            self.mapViewSelected?.putAnnotations(places: trueUnits, supportedAnnotations: true)
        }
    }
    func finishSearchUnits() {
        DispatchQueue.main.async {
            self.lblLoading.isHidden = true
        }
    }
    func finishWithError(error: Error){
        DispatchQueue.main.async {
            self.lblLoading.text = self.titleError
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.lblLoading.isHidden = true
        }
    }
    //MARK: PICKER
    func cancelOption() {
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
    }
    func selectOption(_ option: Int, value: String) {
        guard let filter = SearchUnit(rawValue: value) else {return}
        guard let pickerView = self.pickerView else { return }
        self.searchingFilter = filter
        self.lblLoading.isHidden = true
        pickerView.removeFromSuperview()
        if self.searchingFilter == .closeTo {
            if !UnitsMapViewModel.shared.searchUnits(searchBy: "", searchFilter: self.searchingFilter, location: nil, ratio: self.currentRatio){
                self.lblLoading.text = titleSearch
                self.lblLoading.isHidden = false
            }
            self.gestureLottie.isHidden = false
            self.gestureLottie.play()
        } else {
            self.stackButtonsDistance.isHidden = true
            self.mapViewSelected?.removeCloseAnnotation()
            self.gestureLottie.isHidden  = true
            if !UnitsMapViewModel.shared.searchUnits(searchBy: self.searchingBy, searchFilter: self.searchingFilter, location: nil, ratio: self.currentRatio){
                self.lblLoading.text = titleSearch
                self.lblLoading.isHidden = false
            }
        }
        self.searchBarVC?.searchBar.text = ""
        self.searchingBy = ""
    }
    //MARK: GET UNIT INFO
    func getInfoUnitError(error: Error) {
        self.lottieView?.animationFinishError()
    }
    func getInfoUnit(unitInfo: [String : Any]) {
        DispatchQueue.main.async {
            self.infoUnit?.setUnit(unit: unitInfo)
            //self.infoUnit?.isMyUnit = self.ismyUnit
            self.infoUnit?.isMyUnit = true
            //self.infoUnit?.unitType = 
            self.viewQR.isHidden = true
            self.infoBricks?.isHidden = true
            self.driveOptions?.isHidden = true
        }
    }
}
