//
//  MessageItem.swift
//  Supervisores
//
//  Created by Sharepoint on 9/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct MessageItem: Codable {
    var MensajeId: Int?
    var Asunto: String?
    var Mensaje: String?
    var FechaRegistro: String?
    var FechaEnvio: String?
    var FechaFinPublicacion: String?
    var Directores: Bool?
    var Gerentes: Bool?
    var Supervisores: Bool?
}
