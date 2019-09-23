//
//  TimeSupervision.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 4/3/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class TimeSupervision : Decodable {
    var lapse : String
    var amount : Int
    var type : String
    var id : Int
    var active : Bool

    private enum CodingKeys: String, CodingKey {
        case lapse = "Periodo"
        case amount = "Cantidad"
        case type = "TipoUnidad"
        case id = "PeriodoSupervisionId"
        case active = "Activo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lapse = try container.decodeIfPresent(String.self, forKey: .lapse) ?? ""
        self.amount = try container.decodeIfPresent(Int.self, forKey: .amount) ?? 0
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
    }
}
