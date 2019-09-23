//
//  IndicatorModel.swift
//  Supervisores
//
//  Created by Sharepoint on 7/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
class IndicatorModel: ModelInput {
    
    
    func loadUnit(unit: UnitLite) {
        NetworkingServices.shared.getUnitInfo(unitId: unit.id){  [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidFail()
                print("Error", parsingError)
            }
            do{
                
                let item = try JSONDecoder().decode(UnitInfo.self, from: dataResponse)
                let unitI = try JSONDecoder().decode(Unit.self, from: dataResponse)
                UnitInfoViewModel.shared.unitInfo = item
                unitI.services = item.services
                unitI.id = unit.id
                unitI.key = unit.key
                unitI.type = unit.type
                unitI.bussinesName = unit.bussinesName
                unitI.contact = unit.contact
                unitI.street = unit.street
                unitI.name = unit.name
                unitI.status = item.unidadId
                unitI.statusName = item.unidad
                self.out.modelDidLoad([unitI],from: 2)
                
            }
            catch let error{
                self.out.modelDidFail()
                print("ErrorDescription\(error.localizedDescription)")
            }
            
        }
    }
    
    var itemsResum: [IndicatorResumItem] = []
    func loadOrder(typeOrder: TypeOrder) {
        out.modelDidLoad(OrderByType(type: typeOrder))
    }
    
    func loadStates(indicator: Indicators) {
        if indicator == .gerencia{
            let state = States.init(id: 1, nombre: "Sucursales")
            let state2 = States.init(id: 2, nombre: "Franquicias")
             let items = [state,state2]
                out.modelDidLoad(items)
        }else{
            self.getStates()
        }
       
    }
    
    var out: ModelOutput!
    
    func load(idLevel: Int, idLocation: Int) {
        var idLocatio = idLocation
        if idLevel == 6 {
           
            out.modelDidLoad(MyUnitsViewModel.shared.arrayUnits,from: 1)
            
            return
        }
        if idLevel == 8{
            loadContacto()
            return
        }
        if idLevel == 5{
            idLocatio = 1
        }
        NetworkingServices.shared.getGroupData(idLevel: idLevel, idLocation:idLocatio){  [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidFail()
                print("Error", parsingError)
            }
            do{
                
               let items = try JSONDecoder().decode([IndicatorResumItem].self, from: dataResponse)
                if items.count == 0 {
                 self.out.modelDidFail()
                    return
                }
                self.itemsResum = items
                if idLevel == Indicators.direccion.rawValue{
                    self.itemsResum = self.getItemsCiudad(items: self.itemsResum)
                }
                if idLevel == Indicators.gerencia.rawValue{
                    self.out.modelDidLoad( self.getGerencia(items: self.itemsResum, type: idLocation == 1 ? "S": "F"))
                    return
                }
               // self.itemsResum = self.SetUmbrales(self.itemsResum)
                
                self.out.modelDidLoad(self.itemsResum)
                
            }
            catch let error{
                self.out.modelDidFail()
                print("ErrorDescription\(error.localizedDescription)")
            }
            
        }
    }
    func loadContacto(){
NetworkingServices.shared.getGroupData(idLevel: 8, idLocation:0){  [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidFail()
                print("Error", parsingError)
            }
            do{
                
                let items = try JSONDecoder().decode([ContactoItem].self, from: dataResponse)
              
                self.out.modelDidLoad(items)
            }
            catch let error{
                self.out.modelDidFail()
                print("ErrorDescription\(error.localizedDescription)")
            }
            
        }
    }
    func getStates(){
            let fileName = "States"
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
                
                return
            }
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let items = try JSONDecoder().decode([States].self, from: data)
                self.out.modelDidLoad(items)
            } catch {
                self.out.modelDidFail()
            }
        
    }
    func OrderByType(type: TypeOrder) -> [IndicatorResumItem]{
        let array = self.itemsResum
        switch type {
        case .name:
            return quickSort(array: array)
            break
        case .yearToYear:
            return quickSortValue(array: array)
            break
        default:
            return self.itemsResum
            break
        }
    }
    func quickSort(array: [IndicatorResumItem]) -> [IndicatorResumItem] {
        if array.isEmpty { return [] }
        
        let first = array.first!
        
        let smallerOrEqual = array.dropFirst().filter { $0.LocacionId! <= first.LocacionId! }
        let larger         = array.dropFirst().filter { $0.LocacionId! > first.LocacionId! }
        
        return quickSort(array: smallerOrEqual) + [first] + quickSort(array: larger)
    }
    func quickSortValue(array: [IndicatorResumItem]) -> [IndicatorResumItem] {
        if array.isEmpty { return [] }
        
        let first = array.first!
        
        let smallerOrEqual = array.dropFirst().filter { $0.Nombre! < first.Nombre! }
        let larger         = array.dropFirst().filter { $0.Nombre! > first.Nombre! }
        
        return quickSortValue(array: smallerOrEqual) + [first] + quickSortValue(array: larger)
       
    }
    func getItemsCiudad(items: [IndicatorResumItem]) -> [IndicatorResumItem]{
        var newitems: [IndicatorResumItem] = [itemsResum[6],itemsResum[7],itemsResum[8]]
        newitems[0].Total! += (itemsResum[0].Total! + itemsResum[3].Total!)
        newitems[1].Total! += (itemsResum[1].Total! + itemsResum[4].Total!)
        newitems[2].Total! += (itemsResum[2].Total! + itemsResum[5].Total!)
        newitems[0].Laboratorios! += (itemsResum[0].Laboratorios! + itemsResum[3].Laboratorios!)
        newitems[1].Laboratorios! += (itemsResum[1].Laboratorios! + itemsResum[4].Laboratorios!)
        newitems[2].Laboratorios! += (itemsResum[2].Laboratorios! + itemsResum[5].Laboratorios!)
        newitems[0].Sucursales! += itemsResum[0].Sucursales!
        newitems[1].Sucursales! += itemsResum[1].Sucursales!
        newitems[2].Sucursales! += itemsResum[2].Sucursales!
        newitems[0].Franquicias! += itemsResum[3].Franquicias!
        newitems[1].Franquicias! += itemsResum[4].Franquicias!
        newitems[2].Franquicias! += itemsResum[5].Franquicias!
        return newitems
    }
    func getGerencia(items: [IndicatorResumItem], type: String) -> [IndicatorResumItem] {
        var itemsStore: [IndicatorResumItem] = []
        for i in 0 ..< items.count{
            if type == "S"{
                if items[i].Sucursales! > 0{
                itemsStore.append(items[i])
                }
            }else{
                if items[i].Franquicias! > 0{
                    itemsStore.append(items[i])
                }
            }
            
        }
        if type == "S" {
            return self.quickSort(array: itemsStore)
        }else{
        return self.quickSortValue(array: itemsStore)
        }
    }
    func SetUmbrales(_ items: [IndicatorResumItem]) -> [IndicatorResumItem]  {
        if items.count == 0{
            return []
        }
        var resul = items
        var item = IndicatorCatalog.shared.Catalogue.filter({
            $0.IndicadorId == 16
        })
        guard let umbrales = item[0].Umbrales else {
            return items
        }
        
        var umbral = umbrales.filter({
            (((items[0].Indicador16?.Valor)! > $0.ValorMinimo!) && (items[0].Indicador16?.Valor)! < $0.ValorMaximo!)
            
        })
        guard ((resul[0].Indicador16?.Umbral = umbral[0].Color!) != nil) else{
           return items
        }
        return resul
    }
}
