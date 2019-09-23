//
//  PauseReason.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class PauseReason : Decodable {
    var id : Int
    var active : Bool
    var dateModification : Date?
    var dateRegister : Date?
    var reason : String
    var datePublish : Date?
    
    private enum CodingKeys: String, CodingKey {
        case id = "MotivoPausaId"
        case active = "Activo"
        case dateModification = "FechaModificacion"
        case dateRegister = "FechaRegistro"
        case reason = "MotivoPausa"
        case datePublish = "FechaPublicacion"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason) ?? ""
       
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateRegister) {
            self.dateRegister = Utils.dateFromService(stringDate: stringDate)
        }
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateModification) {
            self.dateModification = Utils.dateFromService(stringDate: stringDate)
        }
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .datePublish) {
            self.datePublish = Utils.dateFromService(stringDate: stringDate)
        }
    }
}

struct PauseSupervision {
    var pauseId : Int
    var pauseDescriptionId : String
    var dateStart : Date?
    var dateEnd : Date?
    
    init(pauseId: Int, pauseDescriptionId: String, dateStart: Date?, dateEnd: Date?){
        self.pauseId = pauseId
        self.pauseDescriptionId = pauseDescriptionId
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }
}
