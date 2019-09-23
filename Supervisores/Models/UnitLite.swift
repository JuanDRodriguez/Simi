//
//  UnitLite.swift
//  Supervisores
//
//  Created by Sharepoint on 25/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class UnitLite : Decodable, Hashable, Equatable {
    static func == (lhs: UnitLite, rhs: UnitLite) -> Bool {
        return lhs.id == rhs.id
    }
    static func != (lhs: UnitLite, rhs: UnitLite) -> Bool {
        return lhs.id != rhs.id
    }
    var hashValue: Int {
        return self.id
    }
    
    var id : Int
    var key : String
    var name : String
    var lat : Double
    var lng : Double
    var type : Int
    var contact : String
    var bussinesName : String
    var street : String
    var cp: String
    var state: String
    var colony : String
    var foundBy : String
    var number : String
    var city: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "UnidadNegocioId"
        case key = "Clave"
        case name = "Nombre"
        case lat = "Latitud"
        case lng = "Longitud"
        case type = "TipoUnidadId"
        case contact = "Contacto"
        case bussinesName = "RazonSocial"
        case street = "Calle"
        case colony = "Colonia"
        case cp = "CodigoPostal"
        case state = "Estado"
        case number = "NumeroExterior"
        case city = "Ciudad"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        self.lng = try container.decodeIfPresent(Double.self, forKey: .lng) ?? 0.0
        self.type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        self.contact = try container.decodeIfPresent(String.self, forKey: .contact) ?? ""
        self.bussinesName = try container.decodeIfPresent(String.self, forKey: .bussinesName) ?? ""
        self.street = try container.decodeIfPresent(String.self, forKey: .street) ?? ""
        self.colony = try container.decodeIfPresent(String.self, forKey: .colony) ?? ""
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.cp =  try container.decodeIfPresent(String.self, forKey: .cp) ?? ""
        self.number = try container.decodeIfPresent(String.self, forKey: .number) ?? "S/N"
        self.city =  try container.decodeIfPresent(String.self, forKey: .city) ?? ""
         self.foundBy = ""
    }
}
