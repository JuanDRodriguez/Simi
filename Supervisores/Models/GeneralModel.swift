//
//  GeneralModel.swift
//  Supervisores
//
//  Created by Sharepoint on 8/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
class GeneralModel {
    var out: GeneralModelOutput!
    func load(key: String){
       let item = MyUnitsViewModel.shared.arrayUnits.filter({$0.key == key})
        NetworkingServices.shared.getUnitInfo(unitId:item[0].id){
            [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidLoadFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
               print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidLoadFail()
                print("Error", parsingError)
                return
            }
            do{
                let itemInf = try JSONDecoder().decode(UnitInfo.self, from: dataResponse)
                Operation.clave = itemInf.claveSupervisor
                Operation.starts = itemInf.starts
                let gItems = GeneralItem.init(numero: item[0].key, nombre: item[0].name, razonSocial: item[0].bussinesName, direccion: "CALLE \(item[0].street)  \(item[0].number) INT: \(item[0].numberInt!) COLONIA \(item[0].colony) MUNICIPIO  \(item[0].municipio!) \(item[0].state) CP \(item[0].cp)", moreInfo: itemInf)
                 let isf = item[0].type == 1 ? true : false
                var array = gItems.getArray()
                if isf{
                    array.remove(at: 0)
                }
                self.out.modelDidLoad((array,gItems.moreInfo.services),isFranquicia: isf)            }
            catch let error{
                self.out.modelDidLoadFail()
                print("ErrorDescription\(error.localizedDescription)")
                return
            }
        }
    }
    func load(key: String, itemInf: UnitInfo){
        let item = UnitsMapViewModel.shared.arrayAllUnits.filter({
            $0.key == key
        })
        Operation.starts = itemInf.starts
        if item.count > 0{
        let gItems = GeneralItem.init(numero: item[0].key, nombre: item[0].name, razonSocial: item[0].bussinesName, direccion: "CALLE \(item[0].street) \(item[0].number) COLONIA \(item[0].colony) MUNICIPIO \(item[0].city)  CP \(item[0].cp)", moreInfo: itemInf)
            let isf = item[0].type == 1 ? true : false
            var array = gItems.getArray()
            if isf{
              array.remove(at: 0)
            }
            self.out.modelDidLoad((array,gItems.moreInfo.services),isFranquicia: isf)
        }else{
            out.modelDidLoadFail()
        }
        
    }
}
