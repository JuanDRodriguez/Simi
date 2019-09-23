//
//  NotasItem.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct  NotasItem {
    var idNota: Int32
    var idUnit: Int32
    var title: String
    var detail: String
    init(idNota: Int32, idUnit: Int32, title: String, detail: String) {
        self.idNota = idNota
        self.idUnit = idUnit
        self.title = title
        self.detail = detail
    }
}
