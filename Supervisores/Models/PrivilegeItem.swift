//
//  PrivilegeItem.swift
//  Supervisores
//
//  Created by Sharepoint on 7/19/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct PrivilegeItem: Decodable {
    var PrivilegioId: Int?
    var Nombre: String?
    var Activo: Bool?
}
struct PrivilegeProfileItem: Decodable {
    var PerfilId: Int?
    var PrivilegioId: Int?
    var FechaRegistro: String?
    var FechaModificacion: String?
    var Activo: Bool?
}
