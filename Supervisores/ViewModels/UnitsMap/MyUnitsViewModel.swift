//
//  UnitsViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 18/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import MapKit

typealias OrderFunction = (Unit, Unit) throws -> Bool

enum KeysUnit: String {
    case idUnit = "idUnit"
    case key = "keyUnit"
    case name = "nameUnit"
    case lat = "latitudeUnit"
    case lng = "longitudeUnit"
    case typeUnit = "typeUnit"
    case contact = "contact"
    case bussinessName = "bussinesNameUnit"
    case street = "streetUnit"
    case colony = "colony"
    case state = "stateUnit"
    case unitIncreaseYBY = "unitIncreaseYBY"
    case openDate = "openDate"
    case lastSupervision = "lastSupervision"
    case numberIssues = "numberIssues"
    case foundBy = "foundBy"
    case number = "NumeroExterior"
}

enum KeysIncreaseYBY: String {
    case id = "idIncreaseYBY"
    case name = "nameIncreaseYBY"
    case value = "valueIncreaseYBY"
}

enum KeysLastSupervision: String {
    case lastSupervision = "lastSupervision"
    case score = "score"
}

enum UnitsType: Int {
    case branchOffice = 1
    case franchise = 2
    case lab = 3
}

@objc protocol MyUnitsVMProtocol {
    func unitsChange(units: [[String: Any]])
    func finishLoadUnits()
    func finishWithError(error: Error)
}

class MyUnitsViewModel {
    static let shared = MyUnitsViewModel()
    var listener: MyUnitsVMProtocol?
    var searching = ""
    var searchFilter : SearchUnit?
    var currentLocation : CLLocation?
    var orderFunctions : [OrderUnit : OrderFunction] = [:]
    
    var  arrayUnits : [Unit] = []
    var arrayUnitsMaped: [[String: Any]] = []
    var arrayUnitsOrderFilter: [Unit] = [] {
        didSet {
            self.arrayUnitsMaped.removeAll()
            for unit in arrayUnitsOrderFilter{
                self.arrayUnitsMaped.append(unitToDictionary(unit: unit))
            }
            self.listener?.unitsChange(units: self.arrayUnitsMaped)
        }
    }
    
    func unitToDictionary(unit: Unit)->[String: Any]{
        var increaseDicto: [String : Any] = [:]
        var lastSupervisionDicto: [String : Any] = [:]
        
        if let increase = unit.increaseYbY {
            increaseDicto = [KeysIncreaseYBY.id.rawValue: increase.id,
                            KeysIncreaseYBY.name.rawValue: increase.name,
                            KeysIncreaseYBY.value.rawValue: increase.value]
        }
        
        if let lastSupervision = unit.lastSupervision {
            lastSupervisionDicto = [KeysLastSupervision.lastSupervision.rawValue: lastSupervision.dateEnd ?? Date(timeIntervalSince1970: 0),
                                    KeysLastSupervision.score.rawValue: lastSupervision.score]
        }
        
        let unitDicto: [String : Any] = [ KeysUnit.idUnit.rawValue: unit.id,
                                          KeysUnit.key.rawValue: unit.key,
                                          KeysUnit.name.rawValue: unit.name,
                                          KeysUnit.lat.rawValue: unit.lat,
                                          KeysUnit.lng.rawValue: unit.lng,
                                          KeysUnit.openDate.rawValue: unit.openDate,
                                          KeysUnit.typeUnit.rawValue: unit.type,
                                          KeysUnit.contact.rawValue: unit.contact,
                                          KeysUnit.bussinessName.rawValue: unit.bussinesName,
                                          KeysUnit.street.rawValue: unit.street,
                                          KeysUnit.state.rawValue : unit.state,
                                          KeysUnit.colony.rawValue : unit.colony,
                                          KeysUnit.numberIssues.rawValue: unit.numberIssues,
                                          KeysUnit.unitIncreaseYBY.rawValue: increaseDicto,
                                          KeysUnit.lastSupervision.rawValue: lastSupervisionDicto,
                                          KeysUnit.foundBy.rawValue: unit.foundBy]
        return unitDicto
    }
    
    init() {
        self.createOrderFunctions()
    }
    
    func setListener(listener: MyUnitsVMProtocol?){
        self.listener = listener
    }
    
    func getMyUnits(orderBy : OrderUnit, ovirrideCurrent : Bool = false) -> Bool {
        if arrayUnits.count > 0 && !ovirrideCurrent {
            arrayUnitsOrderFilter = arrayUnits
            self.listener?.finishLoadUnits()
            return true
        }
        let id = LoginViewModel.shared.loginInfo?.user?.domainAccount
        
        NetworkingServices.shared.getMyUnits (id: id!){
            [unowned self] in
            self.arrayUnits.removeAll()
            if let error = $1 {
                self.reportErrorToListeners(error: error)
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.reportErrorToListeners(error: error)
                return
            }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                print(jsonResponse)
            } catch let parsingError {
                
                print("Error", parsingError)
            }
            do {
            
                let decoder = JSONDecoder()
                self.arrayUnits = try decoder.decode([Unit].self, from: data)
               // self.arrayUnits = []
                self.orderUnits(orderBy: orderBy)
                self.listener?.finishLoadUnits()
            } catch let error {
                self.reportErrorToListeners(error: error)
            }
        }
        return false
    }
        
    func reportErrorToListeners(error: Error){
        self.listener?.finishWithError(error: error)
    }
}
