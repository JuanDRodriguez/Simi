//
//  ContactoItem.swift
//  Supervisores
//
//  Created by Sharepoint on 9/2/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct ContactoItem: Codable {
    var ContactoId: Int?
    var CuentaDominio: String?
    var Nombre: String
    var RazonSocial: String?
    var Activo: Bool?
    var Unidades: Int
    var Indicador16Dto: Indicator16Dto?
}
struct Indicator16Dto: Codable {
    var IndicadorId: Int
    var Nombre: String
    var Valor: Double
}
