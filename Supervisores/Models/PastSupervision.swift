//
//  PastSupervision.swift
//  Supervisores
//
//  Created by Sharepoint on 5/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class PastSupervision: Decodable {
    var user : UserDidSupervision?
    var supervisionId : Int
    var dateBegin: Date?
    var dateEnd: Date?
    var numberBreach: Int
    var isVisit: Bool
    var isNocturne: Bool
    var numberStars: Int
    
    private enum CodingKeys: String, CodingKey {
        case supervisionId = "SupervisionID"
        case dateBegin = "FechaInicio"
        case dateEnd = "FechaFin"
        case numberBreach = "Incumplimientos"
        case isVisit = "Visita"
        case isNocturne = "Nocturna"
        case numberStars = "Estrellas"
        case user = "User"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decodeIfPresent(UserDidSupervision.self, forKey: .user)
        self.supervisionId = try container.decodeIfPresent(Int.self, forKey: .supervisionId) ?? -1
        if let dateStr = try container.decodeIfPresent(String.self, forKey: .dateBegin) {
            self.dateBegin = Utils.dateFromService(stringDate: dateStr)
        }
        if let dateStr = try container.decodeIfPresent(String.self, forKey: .dateEnd) {
            self.dateEnd = Utils.dateFromService(stringDate: dateStr)
        }
        self.isVisit = try container.decodeIfPresent(Bool.self, forKey: .isVisit) ?? false
        self.isNocturne = try container.decodeIfPresent(Bool.self, forKey: .isNocturne) ?? false
        self.numberStars = try container.decodeIfPresent(Int.self, forKey: .numberStars) ?? -1
        self.numberBreach = try container.decodeIfPresent(Int.self, forKey: .numberBreach) ?? -1
    }
}

class UserDidSupervision : Decodable {
    var userId : Int
    var domainAccount : String
    var active : Bool
    var profile : String
    var profileId : Profiles
    
    private enum CodingKeys: String, CodingKey {
        case userId = "UsuarioId"
        case domainAccount = "CuentaDominio"
        case active = "Activo"
        case profile = "Perfil"
        case profileId = "PerfilId"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? -1
        self.domainAccount = try container.decodeIfPresent(String.self, forKey: .domainAccount) ?? ""
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        self.profile = try container.decodeIfPresent(String.self, forKey: .profile) ?? ""
        if let profileId = try container.decodeIfPresent(Int.self, forKey: .profileId) {
            self.profileId = Profiles(rawValue: profileId) ?? .general
        } else {
            self.profileId = .general
        }
    }
}
