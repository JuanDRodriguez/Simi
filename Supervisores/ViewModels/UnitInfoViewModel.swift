//
//  UnitInfoViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 27/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysUnitInfo: String {
    case indicatorId = "indicatorUnitInfo"
    case indicatorName = "indicatorNameUnitInfo"
    case indicatorValue = "valueUnitInfo"
    case services = "servicesUnit"
    case contactName = "contactName"
    case keyUnit = "keyUnitInfo"
    case nameUnit = "nameUnitInfo"
    case unidadId = "EstatusUnidadId"
}

enum KeysServicesUnit: String {
    case serviceId = "serviceId"
    case serviceDescription = "serviceDescription"
}

@objc protocol UnitInfoVMProtocol {
    func getInfoUnitError(error: Error)
    func getInfoUnit(unitInfo: [String: Any])
}

class UnitInfoViewModel {
    static let shared = UnitInfoViewModel()
    var unitsInfo : [Int : UnitInfo] = [:]
    var listener: UnitInfoVMProtocol?
    var unitInfo: UnitInfo!
    init() { }
    
    func setListener(listener: UnitInfoVMProtocol?) {
        self.listener = listener
    }
    func unitInfoToDicto(unitInfo: UnitInfo, contactName: String, keyUnit: String, nameUnit: String)->[String: Any] {
        var services : [[String: Any]] = []
        for service in unitInfo.services {
            let serviceDicto : [String : Any] = [KeysServicesUnit.serviceId.rawValue: service.id,
                                                KeysServicesUnit.serviceDescription.rawValue: service.service]
            services.append(serviceDicto)
        }
        let unitInfoDicto :[String : Any] = [KeysUnitInfo.indicatorId.rawValue: unitInfo.indicator?.id ?? "",
                                             KeysUnitInfo.indicatorName.rawValue: unitInfo.indicator?.name ?? "",
                                             KeysUnitInfo.indicatorValue.rawValue: unitInfo.indicator?.value ?? "",
                                             KeysUnitInfo.contactName.rawValue: contactName,
                                             KeysUnitInfo.keyUnit.rawValue : keyUnit,
                                             KeysUnitInfo.nameUnit.rawValue : nameUnit,
                                             KeysUnitInfo.services.rawValue: services,
                                             KeysUnitInfo.unidadId.rawValue: unitInfo.unidadId
        ]
        
        return unitInfoDicto
    }
    
    func getUnitInfo(unitId: Int, contactName: String, keyUnit: String, nameUnit: String) {
        if let unitInfo = self.unitsInfo[unitId]{
            self.listener?.getInfoUnit(unitInfo: self.unitInfoToDicto(unitInfo: unitInfo, contactName: contactName, keyUnit: keyUnit, nameUnit: nameUnit))
        }
        NetworkingServices.shared.getUnitInfo(unitId: unitId) {
            [unowned self] in
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
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
              print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
                
            }
            do {
                let decoder = JSONDecoder()
                let unitInfo = try decoder.decode(UnitInfo.self, from: data)
                self.unitInfo = unitInfo
                self.unitsInfo[unitId] = unitInfo
                self.listener?.getInfoUnit(unitInfo: self.unitInfoToDicto(unitInfo: unitInfo, contactName: contactName, keyUnit: keyUnit, nameUnit: nameUnit))
            } catch let error {
                self.reportErrorToListeners(error: error)
            }
        }
    }
    
    func reportErrorToListeners(error: Error) {
        self.listener?.getInfoUnitError(error: error)
    }
}
