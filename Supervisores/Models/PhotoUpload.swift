//
//  PhotoUpload.swift
//  Supervisores
//
//  Created by Sharepoint on 5/17/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class PhotoUpload: Decodable {
    var answerId : Int
    var urlImage : [String]
    private enum CodingKeys: String, CodingKey {
        case answerId = "RespuestaId"
        case urlImage = "ImgUrl"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.answerId = try container.decodeIfPresent(Int.self, forKey: .answerId) ?? 0
        self.urlImage = try container.decodeIfPresent([String].self, forKey: .urlImage) ?? []
    }
}
