//
//  ReasonItem.swift
//  Supervisores
//
//  Created by Sharepoint on 8/1/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct ReasonItem: Codable {
    var MotivoId: Int?
    var Activo: Bool?
    var Orden: Int?
    var Nombre: String?
    var TipoVisitaId: Int?
    var  TipoVista: TypeView?
  
}
struct TypeView: Codable {
    var TipoVisitaId: Int?
    var Activo: Bool?
    var Nombre: String?
    var HoraInicio: String?
    var HoraFin: String?
}
