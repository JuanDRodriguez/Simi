//
//  WeighingRange.swift
//  Supervisores
//
//  Created by Sharepoint on 9/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import Foundation

struct WeighingRange: Codable {
    var minValue : Int
    var maxValue: Int
    var stars: Int
    var active: Bool
    var description: String
    var legend: String
    var image: String
    
    private enum CodingKeys: String, CodingKey {
        case minValue = "ValorMinimo"
        case maxValue = "ValorMaximo"
        case stars = "Estrellas"
        case active = "Activo"
        case description = "Descripcion"
        case legend = "Leyenda"
        case image = "Imagen"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.minValue = try container.decodeIfPresent(Int.self, forKey: .minValue) ?? 0
        self.maxValue = try container.decodeIfPresent(Int.self, forKey: .maxValue) ?? 0
        self.stars = try container.decodeIfPresent(Int.self, forKey: .stars) ?? 0
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.legend = try container.decodeIfPresent(String.self, forKey: .legend) ?? ""
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
}
