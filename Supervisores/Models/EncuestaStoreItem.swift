//
//  EncuestaStoreItem.swift
//  Supervisores
//
//  Created by Sharepoint on 9/4/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct EncuestaStoreItem {
    var idEncuesta: Int
    var dateEnd: String
    var instrucciones: String
    var nombre: String
    var destinatario: String
    var count: Int
    init(idEncuesta: Int,dateEnd: String, instrucciones: String, nombre: String, destinatario: String,count: Int) {
        self.idEncuesta = idEncuesta
        self.dateEnd = dateEnd
        self.instrucciones = instrucciones
        self.nombre = nombre
        self.destinatario = destinatario
        self.count = count
    }
}
