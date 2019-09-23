//
//  UnitInfo.swift
//  Supervisores
//
//  Created by Sharepoint on 27/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class UnitInfo : Decodable {
    var services : [Service]
    var indicator : Indicator?
    var unidad: String
    var unidadId: Int
    var claveSupervisor: String
    var gerente: String?
    var cuentaDominio: String?
    var starts: Int
    var Supervisor: String?
    var Director: String?
    var Horario: String?
    var Telefono: String?
    
    private enum CodingKeys: String, CodingKey {
        case services = "Servicios"
        case indicator = "Indicador"
        case unidad = "EstatusUnidad"
        case unidadId = "EstatusUnidadId"
        case claveSupervision = "ClaveSupervisor"
        case gerente = "Gerente"
        case cuentaDominio = "CuentaDominioGerente"
        case starts = "Estrellas"
        case supervisor = "Supervisor"
        case director = "Director"
        case horario = "Horario"
        case telefono = "Telefono"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.services = try container.decode([Service].self, forKey: .services)
        self.indicator = try container.decodeIfPresent(Indicator.self, forKey: .indicator)
        self.unidad = try container.decodeIfPresent(String.self, forKey: .unidad) ?? ""
        self.unidadId = try container.decodeIfPresent(Int.self, forKey: .unidadId) ?? 1
        self.claveSupervisor = try container.decodeIfPresent(String.self, forKey: .claveSupervision) ?? ""
        self.gerente = try container.decodeIfPresent(String.self, forKey: .gerente) ?? ""
        self.cuentaDominio = try container.decodeIfPresent(String.self, forKey: .cuentaDominio) ?? ""
        self.starts = try container.decodeIfPresent(Int.self, forKey: .starts) ?? 0
        self.Horario =  try container.decodeIfPresent(String.self, forKey: .horario) ?? ""
        self.Supervisor = try container.decodeIfPresent(String.self, forKey: .supervisor) ?? ""
        self.Director = try container.decodeIfPresent(String.self, forKey: .director) ?? ""
        self.Telefono = try container.decodeIfPresent(String.self, forKey: .telefono) ?? ""
        
    }
}

class Service : Decodable{
    var id : Int
    var service : String
    private enum CodingKeys: String, CodingKey {
        case id = "ServicioId"
        case service = "Servicio"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.service = try container.decodeIfPresent(String.self, forKey: .service) ?? ""
    }
}

class Indicator : Decodable{
    var id : Int
    var name : String
    var value : Float
    private enum CodingKeys: String, CodingKey {
        case id = "IndicadorId"
        case name = "Nombre"
        case value = "Valor"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.value = try container.decodeIfPresent(Float.self, forKey: .value) ?? 0.0
    }
}
