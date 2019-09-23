//
//  Actions.swift
//  Supervisores
//
//  Created by Sharepoint on 03/04/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class Actions : Decodable {
    var name : String
    var typeAction : String
    var actionId : Int
    var active : Bool
    
    private enum CodingKeys: String, CodingKey {
        case name = "Nombre"
        case typeAction = "Tipo"
        case actionId = "AccionId"
        case active = "Activo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.typeAction = try container.decodeIfPresent(String.self, forKey: .typeAction) ?? ""
        self.actionId = try container.decodeIfPresent(Int.self, forKey: .actionId) ?? -1
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
    }
}
