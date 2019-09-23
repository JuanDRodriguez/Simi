//
//  BreachLevel.swift
//  Supervisores
//
//  Created by Sharepoint on 29/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class BreachLevel : Decodable {
    var id : Int
    var active : Bool
    var name : String
    
    private enum CodingKeys: String, CodingKey {
        case id = "NivelIncumplimientoId"
        case active = "Activo"
        case name = "Nombre"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
