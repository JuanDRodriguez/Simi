//
//  UserInfo.swift
//  Supervisores
//
//  Created by Sharepoint on 25/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class UserInfo: Decodable {
    var token : Token?
    var user : User?
    private enum CodingKeys: String, CodingKey {
        case token = "Token"
        case user = "User"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decodeIfPresent(Token.self, forKey: .token)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
    }
}

class Token : Decodable {
    var accessToken : String
    var tokenType : String
    var expiresIn : Double
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken) ?? ""
        self.tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType) ?? ""
        self.expiresIn = try container.decodeIfPresent(Double.self, forKey: .expiresIn) ?? 0.0
    }
}

class User : Decodable {
    var userId : Int
    var name : String
    var lastName : String
    var middleName : String
    var domainAccount : String
    var contact : [Email]
    var active : Bool
    var profile : String
    var profileId : Profiles
    static var currentProfile =  Profiles.director
    static var typeUnit = 0
    private enum CodingKeys: String, CodingKey {
        case userId = "UsuarioId"
        case name = "NombreCompleto"
        case lastName = "ApellidoPaterno"
        case middleName = "ApellidoMaterno"
        case domainAccount = "CuentaDominio"
        case active = "Activo"
        case profile = "Perfil"
        case profileId = "PerfilId"
        case contact = "Contacto"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.middleName = try container.decodeIfPresent(String.self, forKey: .middleName) ?? ""
        self.domainAccount = try container.decodeIfPresent(String.self, forKey: .domainAccount) ?? ""
        self.contact = try container.decodeIfPresent([Email].self, forKey: .contact) ?? []
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        
        self.profile = try container.decodeIfPresent(String.self, forKey: .profile) ?? ""
        if let profileId = try container.decodeIfPresent(Int.self, forKey: .profileId) {
            self.profileId = Profiles(rawValue: profileId) ?? .general
        } else {
            self.profileId = .general
        }
    }
}

class Email: Decodable {
    var email : String
    private enum CodingKeys: String, CodingKey {
        case email = "Correo"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
}
