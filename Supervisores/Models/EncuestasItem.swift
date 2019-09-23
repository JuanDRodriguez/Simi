//
//  EncuestasItem.swift
//  Supervisores
//
//  Created by Sharepoint on 8/29/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct EncuestasItem: Codable {
    var EncuestaId : Int?
    var Nombre: String?
    var FechaInicio: String?
    var FechaTermino: String?
    var FechaPublicacion: String?
    var EstatusEncuestaId: Int?
    var InstruccionesId: Int?
    var FechaModificacion: String?
    var DESTINATARIO: String?
    var EstatusEncuesta: EncuestaEstatusItem?
    var Instrucciones: InstruccionesItem?
}
struct InstruccionesItem: Codable {
        var Instrucciones: String?
        var InstruccionesId: Int?
        var Activo: Bool?
        var FechaRegistro:String?
        var FechaModificacion: String?
    
}
struct EncuestaEstatusItem: Codable {
    var EstatusEncuestaId: Int?
    var Estatus: String?
    var Activo: Bool?
    var FechaRegistro: String?
    var FechaModificacion: String?
}
