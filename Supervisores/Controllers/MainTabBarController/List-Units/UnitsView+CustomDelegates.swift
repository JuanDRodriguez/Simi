//
//  UnitsView+Delegates.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation

extension UnitsViewController: PickerSelectViewDelegate, LocationProtocol, MyUnitsVMProtocol, SearchingProtocol {
    // MARK: Localization Delegate
    func locationNotAllowed() {
        self.appPermissionView = AppPermissions(frame: self.view.frame, permision: Permissions.location)
        guard let permission = self.appPermissionView else {
            return
        }
        self.view.addSubview(permission)
    }
    
    func locationAllowed(){
        guard let permission = self.appPermissionView else {
            return
        }
        permission.removeFromSuperview()
        self.appPermissionView = nil
    }
    
    func updateLocation(newLocation: CLLocation) {
        self.currentLocation = newLocation
        MyUnitsViewModel.shared.currentLocation = newLocation
        DispatchQueue.main.async {
            self.unitList.reloadData()
        }
    }
    // MARK: Picker Delegate
    func selectOption(_ option: Int, value: String) {
        guard let order = OrderUnit(rawValue: value) else {return}
        self.currentOder = order
        self.lblInfoText.text = self.currentOder.rawValue
        MyUnitsViewModel.shared.orderUnits(orderBy: order)
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
    }
    func cancelOption() {
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
    }
    // MARK: VM Delegate
    func unitsChange(units: [[String : Any]]) {
        self.unitsList.removeAll()
        self.unitsByState.removeAll()
        self.arrayHeaders.removeAll()
        if units.count == 0{
            self.delegate.noUnits()
        }
        self.unitsList = units.filter({
            guard let type = $0[KeysUnit.typeUnit.rawValue] as? Int else {
                return false
            }
            return type != UnitsType.lab.rawValue
        })
        for unit in self.unitsList {
            if let state = unit[KeysUnit.state.rawValue] as? String {
                let stateClean = state.folding(options: .diacriticInsensitive, locale: .current)
                if self.unitsByState[stateClean] != nil {
                    self.unitsByState[stateClean]?.append(unit)
                } else {
                    self.unitsByState[stateClean] = [unit]
                    self.arrayHeaders.append(stateClean)
                }
            }
        }
        
            self.unitList.reloadData()
       
    }
    func finishLoadUnits() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.lottieView?.animationFinishCorrect()
        }
    }
    func finishWithError(error: Error) {
        self.lottieView?.animationFinishError()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.unitList.reloadData()
        }
    }
    // MARK: Search Delegate
    func typingSearch(text: String) {
        self.textSearching = text.count > 2 ? text : ""
        MyUnitsViewModel.shared.filerUnits(filterBy: text)
    }
}
