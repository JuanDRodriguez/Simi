//
//  NotasModel.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
class NotasModel: NotasModelInput {

    var out: NotasModelOutput!
    var items: [NotasItem] = []
    var idUnit: Int32!
    var name: String!
    func load(id: Int32) {
        self.items = Storage.shared.getNotas(idUnit: self.idUnit)
        out.modelDidLoad(items)
    }
    func Update(item: (Int, String, String)) {
        
        Storage.shared.updateNotas(nota: NotasItem.init(idNota: Int32(item.0), idUnit: self.idUnit, title: item.1, detail: item.2))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7){
        self.items = Storage.shared.getNotas(idUnit: self.idUnit)
        
        self.out.modelDidLoad(self.items)
        }
    }
    
    func delete(item: NotasItem) {
        Storage.shared.deleteNota(nota: item)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7){
            self.items = Storage.shared.getNotas(idUnit: self.idUnit)
            
            self.out.modelDidLoad(self.items)
        }
    }
}

