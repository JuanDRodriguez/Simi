//
//  VisistItem.swift
//  Supervisores
//
//  Created by Sharepoint on 8/2/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct VisistItem {
    var Comentario: String
    var FechaFin: String?
    var FechaInicio: String?
    var fotografias: [Fotografias]?
    var Latitud: Double
    var Longitud: Double
    var motivos: [Motivos]
    var UnidadNegocioId: Int
    var usuario: Usuario
    var UsuarioId: Int
    var VisitaId: Int
    init(_ dict: [String: Any]) {
        self.Comentario = dict["Comentario"] as! String ?? ""
        self.FechaFin = dict["FechaFin"] as? String ?? ""
        self.FechaInicio = dict["FechaInicio"] as? String ?? ""
        self.Latitud = dict["Latitud"] as! Double ?? 0.0
        self.Longitud = dict["Longitud"] as! Double ?? 0.0
        self.UnidadNegocioId = dict["UnidadNegocioId"] as! Int ?? 0
        self.usuario = Usuario.init(dict["Usuario"] as! [String: Any])
        self.UsuarioId = dict["UsuarioId"] as! Int ?? 0
        self.VisitaId = dict["VisitaId"] as! Int ?? 0
        var motivos = [Motivos]()
        let itemsMotivos = dict["Motivos"] as! [[String: Any]]
        for item in itemsMotivos{
            motivos.append(Motivos.init(item))
        }
        self.motivos = motivos
        var fotos = [Fotografias]()
        let itemsFotos = dict["Fotografias"] as! [[String: Any]]
        for item in itemsFotos {
            fotos.append(Fotografias.init(item))
        }
        self.fotografias = fotos
    }
}
struct Motivos {
    var MotivoId: Int
    var VisitaId: Int
    var Motivo: String
    init(_ dict: [String : Any]) {
        self.Motivo = dict["Motivo"] as! String ?? ""
        self.MotivoId = dict["MotivoId"] as! Int ?? 0
        self.VisitaId = dict["VisitaId"] as! Int ?? 0
    }
}
struct Fotografias {
    var Url: String
    var FotografiaId: Int
    var RespuestaId: Int
    var VisitaId: Int
    init(_ dict: [String : Any]) {
        self.Url  = dict["Url"] as! String ?? ""
        self.FotografiaId = dict["FotografiaId"] as! Int ?? 0
        self.RespuestaId = dict["RespuestaId"] as! Int ?? 0
        self.VisitaId = dict["VisitaId"] as! Int ?? 0
    }
}
struct Usuario {
    var Activo: Bool
    var CorreoElectronico: String
    var CuentaDominio:String
    var NombreCompleto: String
    var NumeroEmpleado: String?
    var Perfil: String
    var PerfilId: Int
    var UsuarioId: Int
    init(_ dict: [String : Any]) {
        self.Activo = dict["Activo"] as! Bool
        self.CorreoElectronico = dict["CorreoElectronico"] as! String
        self.CuentaDominio = dict["CuentaDominio"] as! String
        self.NombreCompleto = dict["NombreCompleto"] as! String
        self.NumeroEmpleado = dict["NumeroEmpleado"] as? String
        self.Perfil = dict["Perfil"] as! String
        self.PerfilId = dict["PerfilId"] as! Int
        self.UsuarioId = dict["UsuarioId"] as! Int
    }
}
