//
//  GeneralItem.swift
//  Supervisores
//
//  Created by Sharepoint on 8/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct GeneralItem {
    var numero: String
     var nombre: String
     var razonSocial: String
     var direccion: String
    var moreInfo: UnitInfo
    init(numero: String, nombre: String, razonSocial: String, direccion: String, moreInfo: UnitInfo) {
        self.numero = numero
        self.nombre = nombre
        self.razonSocial = razonSocial
        self.direccion = direccion
        self.moreInfo = moreInfo
    }
    func getArray() -> [String]{
        var array: [String] = []
        array.append(self.razonSocial)
        array.append(self.direccion)
        array.append(self.moreInfo.Telefono!)
         array.append(self.moreInfo.Horario!)
         array.append("\(self.moreInfo.claveSupervisor) \(self.moreInfo.Supervisor!)")
         array.append(self.moreInfo.gerente!)
        array.append(self.moreInfo.Director!)
        array.append("\(self.moreInfo.starts)")
       
        return array
    }
}
