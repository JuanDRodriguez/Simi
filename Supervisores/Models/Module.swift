//
//  Module.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class Module : Decodable {
    var id : Int
    var name : String
    var order : Int
    var type : String
    var image : UIImage
    var active : Bool
    var dateRegister : Date
    var dateChange: Date
    var percentFinish : Int
    var numberQuestions : Int
    var currentQuestion: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "ModuloId"
        case name = "Nombre"
        case order = "Orden"
        case type = "Tipo"
        case image = "Imagen"
        case active = "Activo"
        case dateRegister = "FechaRegistro"
        case dateChange = "FechaModificacion"
        case numberQuestions = "Preguntas"
        case currentQuestion = "currentQuestion"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateRegister) {
            self.dateRegister = dateFormatter.date(from: stringDate) ?? Date(timeIntervalSince1970: 0)
        } else {
            self.dateRegister = Date(timeIntervalSince1970: 0)
        }
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateChange) {
            self.dateChange = dateFormatter.date(from: stringDate) ?? Date(timeIntervalSince1970: 0)
        } else {
            self.dateChange = Date(timeIntervalSince1970: 0)
        }
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.order = try container.decodeIfPresent(Int.self, forKey: .order) ?? -1
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        self.numberQuestions = try container.decodeIfPresent(Int.self, forKey: .numberQuestions) ?? 0

        
        if let stringImage = try container.decodeIfPresent(String.self, forKey: .image) {
            self.image = Utils.base64ToImage(base64String: stringImage)
        } else {
            self.image = #imageLiteral(resourceName: "no_image_found")
        }
        self.percentFinish = 0
        self.currentQuestion = 0
    }
    
    init(module: ModuleStored, percentFinish: Int, currentQuestion: Int) {
        self.id = Int(module.id)
        self.name = module.name ?? ""
        self.order = Int(module.order)
        self.type = module.type ?? ""
        self.active = module.active
        self.dateRegister = module.dateRegister ?? Date(timeIntervalSince1970: 0)
        self.dateChange = module.dateChange ?? Date(timeIntervalSince1970: 0)
        self.percentFinish = percentFinish
        self.numberQuestions = Int(module.numberQuestions)
        self.currentQuestion = currentQuestion
        if let data = module.image {
            self.image = UIImage(data: data) ?? #imageLiteral(resourceName: "no_image_found")
        } else {
            self.image = #imageLiteral(resourceName: "no_image_found")
        }
    }
}
