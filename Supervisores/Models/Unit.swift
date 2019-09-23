//
//  Units.swift
//  Supervisores
//
//  Created by Sharepoint on 23/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class Unit : Decodable, Hashable, Equatable {
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.id == rhs.id
    }
    static func != (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.id != rhs.id
    }
//    var hashValue: Int {
//        return self.id
//    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
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
    var state: String
    var colony : String
    var openDate : Date
    var foundBy : String
    var increaseYbY: IncreaseYearByYear?
    var lastSupervision: LastSupervision?
    var unitIndicator: IncreaseYearByYear?
    var numberIssues: Int
    var services : [Service]?
    var status: Int
    var statusName: String
    var cp: String
    var number: String
    var numberInt: String?
    var municipio: String?
    var ciudad: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "UnidadNegocioId"
        case key = "Clave"
        case name = "Nombre"
        case lat = "Latitud"
        case lng = "Longitud"
        case type = "TipoUnidadId"
        case contact = "Contacto"
        case bussinesName = "RazonSocial"
        case openDate = "FechaApertura"
        case street = "Calle"
        case colony = "Colonia"
        case increaseYbY = "Indicador"
        case state = "Estado"
        case lastSupervision = "UltimaSupervision"
        case numberIssues = "Incumplimientos"
        case services = "Servicios"
        case cp = "CodigoPostal"
        case number = "NumeroExterior"
        case numberInt = "NumeroInterior"
        case unitIndicator = "UnidadIndicador"
        case ciudad = "Ciudad"
        case municipio = "Municipio"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .openDate) {
            self.openDate = Utils.dateFromService(stringDate: stringDate)
        } else {
            self.openDate = Date(timeIntervalSince1970: 0)
        }
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        self.lng = try container.decodeIfPresent(Double.self, forKey: .lng) ?? 0.0
        self.type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        self.numberIssues = try container.decodeIfPresent(Int.self, forKey: .numberIssues) ?? 0
        self.contact = try container.decodeIfPresent(String.self, forKey: .contact) ?? ""
        self.bussinesName = try container.decodeIfPresent(String.self, forKey: .bussinesName) ?? ""
        self.street = try container.decodeIfPresent(String.self, forKey: .street) ?? ""
        self.colony = try container.decodeIfPresent(String.self, forKey: .colony) ?? ""
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.increaseYbY = try container.decodeIfPresent(IncreaseYearByYear.self, forKey: .increaseYbY) ?? nil
         self.unitIndicator = try container.decodeIfPresent(IncreaseYearByYear.self, forKey: .unitIndicator) ?? nil
        self.lastSupervision = try container.decodeIfPresent(LastSupervision.self, forKey: .lastSupervision) ?? nil
        self.foundBy = ""
         self.services = try container.decode([Service].self, forKey: .services)
        self.status = 1
        self.cp = try container.decodeIfPresent(String.self, forKey: .cp) ?? ""
        self.statusName = ""
        self.number = try container.decodeIfPresent(String.self, forKey: .number) ??  "NA"
        self.ciudad = try container.decodeIfPresent(String.self, forKey: .ciudad) ??  ""
        self.municipio = try container.decodeIfPresent(String.self, forKey: .municipio) ??  ""
        self.numberInt = try container.decodeIfPresent(String.self, forKey: .numberInt) ??  "NA"
    }
}

class IncreaseYearByYear : Decodable{
    var id : Int
    var name : String
    var value : Double
    
    private enum CodingKeys: String, CodingKey {
        case id = "IndicadorId"
        case name = "Nombre"
        case value = "Valor"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.value = try container.decodeIfPresent(Double.self, forKey: .value) ?? 0.0
    }
}

class LastSupervision : Decodable{
    var dateEnd : Date?
    var score : Int
    private enum CodingKeys: String, CodingKey {
        case dateEnd = "FechaFin"
        case score = "Calificacion"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateEnd) {
            self.dateEnd =  Utils.dateFromService(stringDate: stringDate)
        } else {
            self.dateEnd = nil
        }
        self.score = try container.decodeIfPresent(Int.self, forKey: .score) ?? 0
    }
}
