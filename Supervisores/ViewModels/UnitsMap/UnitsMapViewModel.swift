//
//  UnitsMapViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 25/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import MapKit

protocol UnitsMapVMProtocol {
    func unitsSearched(units: [[String: Any]])
    func finishSearchUnits()
    func finishWithError(error: Error)
}

class UnitsMapViewModel {
    static let shared = UnitsMapViewModel()
    var listener: UnitsMapVMProtocol?
    var searching = ""
    var searchFilter : SearchUnit?
    var currentRatio : Double = 5.0
    var currentLocation : CLLocation?
    var locationSearch : CLLocationCoordinate2D?
    var arrayAllUnits : [UnitLite] = []
    var arrayUnitsMaped: [[String: Any]] = []
    var isSearching = false
    var arrayUnitsSearched: [UnitLite] = [] {
        didSet {
            self.arrayUnitsMaped.removeAll()
            self.arrayUnitsMaped = self.arrayUnitsSearched.map({unitToDictionary(unit: $0)})
            self.listener?.unitsSearched(units: self.arrayUnitsMaped)
        }
    }
    init() { }
    func unitToDictionary(unit: UnitLite)->[String: Any]{
        let unitDicto: [String : Any] = [ KeysUnit.idUnit.rawValue: unit.id,
                                          KeysUnit.key.rawValue: unit.key,
                                          KeysUnit.name.rawValue: unit.name,
                                          KeysUnit.lat.rawValue: unit.lat,
                                          KeysUnit.lng.rawValue: unit.lng,
                                          KeysUnit.typeUnit.rawValue: unit.type,
                                          KeysUnit.contact.rawValue: unit.contact,
                                          KeysUnit.bussinessName.rawValue: unit.bussinesName,
                                          KeysUnit.street.rawValue: unit.street,
                                          KeysUnit.state.rawValue : unit.state,
                                          KeysUnit.colony.rawValue : unit.colony,
                                          KeysUnit.foundBy.rawValue: unit.foundBy,
                                          KeysUnit.number.rawValue: unit.number]
        return unitDicto
    }
    
    func setListener(listener: UnitsMapVMProtocol?){
        self.listener = listener
    }
    
    func getAllUnits(override : Bool = false) {
        if self.arrayAllUnits.count == 0 || override {
            self.isSearching = true
            NetworkingServices.shared.getAllUnits(){
                [unowned self] in
                self.listener?.finishSearchUnits()
                if let error = $1 {
                    self.reportErrorToListeners(error: error)
                    self.isSearching = false
                    return
                }
                
                guard let data = $0 else {
                    let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                    self.reportErrorToListeners(error: error)
                    self.isSearching = false
                    return
                }
                do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
           // print(jsonResponse) //Response result
                } catch let parsingError {
                    print("Error", parsingError)
                    
                }
                do {
                    let decoder = JSONDecoder()
                    self.arrayAllUnits = try decoder.decode([UnitLite].self, from: data)
                    if let filter = self.searchFilter {
                        if self.searching != "" || self.locationSearch != nil {
                            let _ = self.searchUnits(searchBy: self.searching, searchFilter: filter, location: self.locationSearch, ratio: self.currentRatio)
                        }
                    }
                    self.isSearching = false
                } catch let error {
                    print("Error\(error.localizedDescription)")
                    self.reportErrorToListeners(error: error)
                    self.isSearching = false
                }
            }
        }else{
           // self.listener?.finishSearchUnits()
        }
    }
    
    func reportErrorToListeners(error: Error){
        self.listener?.finishWithError(error: error)
    }
    
    func getInfoUnit(id: Int)->(String, String){
        let filterUnits = MyUnitsViewModel.shared.arrayUnits.filter({
            $0.id == id
        })
        if filterUnits.count > 0 {
            let unit = filterUnits[0]
            return (unit.key, "CALLE \(unit.street), NUMERO \(unit.number) COLONIA \(unit.colony) MUNICIPIO \(unit.municipio) CP \(unit.cp)")
        }
        return ("", "")
    }
    
    func searchUnits(searchBy: String, searchFilter: SearchUnit, location: CLLocationCoordinate2D? = nil, ratio : Double = 0.0)->Bool{
        self.currentRatio = ratio
        self.arrayUnitsSearched.removeAll()
        self.searching = searchBy.lowercased()
        self.locationSearch = location
        let searchByCant = (searchFilter == .key ? 2 : 3)
        if searchBy.count < searchByCant && location == nil {
            return true
        }
        var isExact = false
        if let lastCharacter = searchBy.last {
            if lastCharacter == " " {
                isExact = true
                self.searching = String(self.searching.dropLast())
            }
        }
        self.searchFilter = searchFilter
        if self.arrayAllUnits.count > 0 {
            switch searchFilter {
                case .name:
                    self.arrayUnitsSearched = self.arrayAllUnits.filter({
                        $0.foundBy = "\(searchFilter.rawValue): \($0.name)"
                        if isExact {
                            return $0.name.lowercased() == self.searching
                        } else {
                            return $0.name.lowercased().contains(self.searching)
                        }
                    })
                case .bussinesName:
                    self.arrayUnitsSearched = self.arrayAllUnits.filter({
                        $0.foundBy = "\(searchFilter.rawValue): \($0.bussinesName)"
                        if isExact {
                            return $0.bussinesName.lowercased() == self.searching && $0.type != UnitsType.branchOffice.rawValue
                        } else {
                            return $0.bussinesName.lowercased().contains(self.searching) && $0.type != UnitsType.branchOffice.rawValue
                        }
                    })
                case .colony:
                    self.arrayUnitsSearched = self.arrayAllUnits.filter({
                        $0.foundBy = "\(searchFilter.rawValue): \($0.colony)"
                        if isExact {
                            return $0.colony.lowercased() == self.searching
                        } else {
                            return $0.colony.lowercased().contains(self.searching)
                        }
                    })
                case .contact:
                    self.arrayUnitsSearched = self.arrayAllUnits.filter({
                        $0.foundBy = "\(searchFilter.rawValue): \($0.contact)"
                        if isExact {
                            return $0.contact.lowercased() == self.searching
                        } else {
                            return $0.contact.lowercased().contains(self.searching)
                        }
                    })
                case .key:
                    self.arrayUnitsSearched = self.arrayAllUnits.filter({
                        $0.foundBy = "\(searchFilter.rawValue): \($0.key)"
                        if isExact {
                            return $0.key.lowercased() == self.searching
                        } else {
                            return $0.key.lowercased().contains(self.searching)
                        }
                    })
                case .street:
                    self.arrayUnitsSearched = self.arrayAllUnits.filter({
                        $0.foundBy = "\(searchFilter.rawValue): \($0.street)"
                        if isExact {
                            return $0.street.lowercased() == self.searching
                        } else {
                            return $0.street.lowercased().contains(self.searching)
                        }

                    })
                case .closeTo:
                    self.arrayUnitsSearched = self.arrayAllUnits.filter({
                        guard let currentLocation = self.locationSearch else {return false}
                        let locationUnit = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng)
                        let distance = locationUnit.distance(from: currentLocation) / 1000
                        $0.foundBy = "\($0.key) - \($0.name): \(String(format: "%.2f", distance))km"
                        return distance < ratio
                    })
            }
            return true
        } else {
            if !self.isSearching {
                self.getAllUnits()
            }
            return false
        }
    }
}
