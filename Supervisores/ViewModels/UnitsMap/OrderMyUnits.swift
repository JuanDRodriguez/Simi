//
//  OrderFilterUnits.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 1/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import MapKit

extension MyUnitsViewModel {
    func createOrderFunctions() {
         orderFunctions = [
            OrderUnit.distance : {[unowned self] in
                guard let currentLocation = self.currentLocation else {return false}
                let location1 = CLLocation(latitude: $0.lat as CLLocationDegrees, longitude: $0.lng as CLLocationDegrees)
                let location2 = CLLocation(latitude: $1.lat as CLLocationDegrees, longitude: $1.lng as CLLocationDegrees)
                return currentLocation.distance(from: location1) < currentLocation.distance(from: location2)
            },
            OrderUnit.unitName: {
                $0.name < $1.name
            },
            OrderUnit.newOpen: {
                $0.openDate > $1.openDate
            },
            OrderUnit.increaseYby: {
                guard let increase1 = $0.increaseYbY else {
                    return false
                }
                guard let increase2 = $1.increaseYbY else {
                    return true
                }
                return increase1.value < increase2.value
            },
            OrderUnit.amountIssues: {
                $0.numberIssues > $1.numberIssues
            },
            OrderUnit.lastSupervision: {
                guard let lastSupervision1 = $0.lastSupervision else {
                    return false
                }
                guard let date1 = lastSupervision1.dateEnd else {
                    return false
                }
                guard let lastSupervision2 = $1.lastSupervision else {
                    return true
                }
                guard let date2 = lastSupervision2.dateEnd else {
                    return true
                }
                return date1 < date2
            }
        ]
    }
    func orderUnits(orderBy: OrderUnit){
        if let orderFunction = orderFunctions[orderBy] {
            do {
                arrayUnits = try arrayUnits.sorted(by: orderFunction)
                arrayUnitsOrderFilter = arrayUnits
            } catch {
                
            }
        }
    }
    func filerUnits(filterBy: String){
        if filterBy.count >= 3 {
            arrayUnitsOrderFilter = arrayUnits.filter({
                let keysToSearch = self.getKeysToSearch(unit : $0)
                for (key, value) in keysToSearch {
                    if value.lowercased().contains(filterBy.lowercased()) {
                        $0.foundBy = "\(key): \(value)"
                        return true
                    }
                }
                $0.foundBy = ""
                return false
            })
        } else {
            arrayUnitsOrderFilter = arrayUnits
        }
    }
    
    func getKeysToSearch(unit: Unit)->[String: String]{
        let keysToSearch: [String: String] = ["Nombre": unit.name,
                                              "Razón social": unit.bussinesName,
                                              "Número de unidad": unit.key,
                                              "Nombre de contacto": unit.contact,
                                              "Calle": unit.street,
                                              "Colonia": unit.colony]
        return keysToSearch
    }
}
