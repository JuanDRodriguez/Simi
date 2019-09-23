//
//  TestBlocks.swift
//  Supervisores
//
//  Created by Sharepoint on 03/10/18.
//  Copyright © 2018 Sharepoint. All rights reserved.
//

import Foundation
import UIKit

class Bricks : Decodable {
    var features : [Block]
}

class Block : Decodable{
    var geometry : Geometry
    var properties : Properties
    var isVisible : Bool?
}

class Properties : Decodable {
    var name : String
    var state : String
    var town : String
    var brick : String
    var totalMarket : String
    var participationBrick : String
    var amountBrick : String
    var tagState : String
    var chanceBrick : String
    var color : UIColor?
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case state = "ESTADO"
        case town = "MUNICIPIO"
        case brick = "BRICK"
        case totalMarket = "MERCADO TOTAL"
        case participationBrick = "PARTICIPACIÓN BRICK"
        case amountBrick = "IMPORTE BRICK"
        case tagState = "REFERENTE POR ESTADO"
        case chanceBrick = "OPORTUNIDAD EN $"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else {
            self.name = ""
        }
        if let state = try container.decodeIfPresent(String.self, forKey: .state) {
            self.state = state
        } else {
            self.state = ""
        }
        if let brick = try container.decodeIfPresent(String.self, forKey: .brick) {
            self.brick = brick
        } else {
            self.brick = ""
        }
        if let town = try container.decodeIfPresent(String.self, forKey: .town) {
            self.town = town
        } else {
            self.town = ""
        }
        if let totalMarket = try container.decodeIfPresent(String.self, forKey: .totalMarket) {
            self.totalMarket = totalMarket
        } else {
            self.totalMarket = ""
        }
        if let participationBrick = try container.decodeIfPresent(String.self, forKey: .participationBrick) {
            self.participationBrick = participationBrick
        } else {
            self.participationBrick = ""
        }
        if let amountBrick = try container.decodeIfPresent(String.self, forKey: .amountBrick) {
            self.amountBrick = amountBrick
        } else {
            self.amountBrick = ""
        }
        if let tagState = try container.decodeIfPresent(String.self, forKey: .tagState) {
            self.tagState = tagState
        } else {
            self.tagState = ""
        }
        if let chanceBrick = try container.decodeIfPresent(String.self, forKey: .chanceBrick) {
            self.chanceBrick = chanceBrick
        } else {
            self.chanceBrick = ""
        }
        let participation = participationBrick.replacingOccurrences(of: "%", with: "")
        let chance = chanceBrick.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        
        if let participacionNum = Float(participation), let chanceNum = Float(chance) {
            self.color = getColor(chance: chanceNum, participacion: participacionNum)
        } else {
            self.color = .clear
        }
    }
}

func getColor(chance : Float, participacion : Float) -> UIColor{
    if participacion >= 50 {
        return .clear
    }
    switch chance {
    case 0.0..<500_000.0:
        return UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3)
    case 500_000.0...1_000_000.0:
        return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.3)
    default:
        return UIColor(red: 83.0 / 255.0, green:159.0 / 255.0, blue: 236.0 / 255.0, alpha: 0.3)
    }
}

class Geometry: Decodable {
    var coordinates : [[[[Coordinates]]]]
    private lazy var allLongitures : [Double] = {
            let longs = coordinates.first?.first?.compactMap { $0.first }.map({(item) in getCoordinateG(coordinate:item)})
            if longs != nil{ return longs! }
            return []
    }()
    private lazy var allLatitudes : [Double] = {
            let lats = coordinates.first?.first?.compactMap { $0.last }.map({(item) in getCoordinateG(coordinate:item)})
            if lats != nil{ return lats! }
            return []
    } ()
    func getCoordinateG(coordinate : Coordinates) -> Double{
        switch coordinate {
        case .double(let double): return double
        }
    }
    lazy var centerBlock : (Double, Double) = {        
        let latP = (topLat + bottomLat) / 2.0
        let lonP = (westLong + eastLong) / 2.0
        return (latP, lonP)
    }()
    lazy var westLong : Double = {
        guard let minLong = allLongitures.min() else { return -180.0 }
        return minLong
    }()
    lazy var eastLong : Double = {
        guard let maxLong = allLongitures.max() else { return 180.0 }
        return maxLong
    }()
    lazy var topLat : Double = {
        guard let top = allLatitudes.max() else { return 90.0 }
        return top
    }()
    lazy var bottomLat : Double = {
        guard let bottom = allLatitudes.min() else { return -90.0 }
        return bottom
    }()
    var maxDistance : Double? = 0.0
}

enum Coordinates: Decodable {
    case double(Double)
    init(from decoder: Decoder) throws {
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        throw CoordinateError.doubleNotFound
    }
    enum CoordinateError: Error {
        case doubleNotFound
    }
}


//"features": [
//{ "type": "Feature", "properties": { "Name": "02001001", "description": null, "altitudeMode": "clampToGround", "NUM F.S.": "5", "OPORTUNIDAD AL 50%": "12,084", "OPORTUNIDAD EN $ C\/EST": "$-", "PARTICIPACIÓN BRICK": "40%", "OPORTUNIDAD EN $": "$475,626", "PZAS F.S. MED": "46,552", "IMPORTE F.S.": "$2,451,863", "PIEZAS BRICK": "70.72", "FID": "1", "REFERENTE POR ESTADO": "36%", "MERCADO TOTAL": "117,272", "NOMBRE": "AGS. CENTRO CP20000", "BRICK": "2001001", "ESTADO": "2 - AGUASCALIENTES", "IMPORTE BRICK": "$12,187,891", "MUNICIPIO": "AGUASCALIENTES", "Field_1": "02001001" }, "geometry": { "type": "MultiPolygon", "coordinates" : [ [ [ [ -102.249602, 21.843922 ], [ -102.248396, 21.845572 ], [ -102.248065, 21.846027 ], [ -102.247761, 21.846503 ], [ -102.247344, 21.847157 ], [ -102.247102, 21.847522 ], [ -102.246912, 21.847832 ], [ -102.246612, 21.848298 ], [ -102.246122, 21.84913 ], [ -102.246334, 21.84973 ], [ -102.245656, 21.849951 ], [ -102.245346, 21.850071 ], [ -102.245018, 21.850326 ], [ -102.244671, 21.850578 ], [ -102.244309, 21.851342 ], [ -102.244322, 21.851909 ], [ -102.244402, 21.851942 ], [ -102.244755, 21.85207 ], [ -102.245151, 21.852213 ], [ -102.245568, 21.852363 ], [ -102.246488, 21.852695 ], [ -102.24698, 21.852873 ], [ -102.247459, 21.853046 ], [ -102.247863, 21.853203 ], [ -102.248242, 21.853329 ], [ -102.248628, 21.853486 ], [ -102.248635, 21.853871 ], [ -102.248646, 21.85428 ], [ -102.248609, 21.854655 ], [ -102.248576, 21.855927 ], [ -102.24868, 21.855845 ], [ -102.248719, 21.855809 ], [ -102.248643, 21.856389 ], [ -102.249055, 21.855981 ], [ -102.249497, 21.855587 ], [ -102.249941, 21.855251 ], [ -102.250454, 21.854858 ], [ -102.250761, 21.854604 ], [ -102.251158, 21.854319 ], [ -102.251889, 21.853748 ], [ -102.25193, 21.853797 ], [ -102.251429, 21.855114 ], [ -102.251129, 21.855772 ], [ -102.250899, 21.856304 ], [ -102.250986, 21.856587 ], [ -102.250815, 21.857749 ], [ -102.251816, 21.856751 ], [ -102.252138, 21.856503 ], [ -102.252419, 21.856329 ], [ -102.252718, 21.856194 ], [ -102.253021, 21.856075 ], [ -102.253534, 21.855932 ], [ -102.255173, 21.855538 ], [ -102.256889, 21.855124 ], [ -102.257006, 21.855094 ], [ -102.25863, 21.85469 ], [ -102.260274, 21.854295 ], [ -102.261948, 21.853881 ], [ -102.263598, 21.853484 ], [ -102.265245, 21.853079 ], [ -102.266899, 21.85265 ], [ -102.269275, 21.852064 ], [ -102.27049, 21.851791 ], [ -102.271141, 21.85156 ], [ -102.271901, 21.851133 ], [ -102.272179, 21.850925 ], [ -102.272548, 21.850587 ], [ -102.273301, 21.849847 ], [ -102.272898, 21.844888 ], [ -102.272508, 21.844622 ], [ -102.270837, 21.844934 ], [ -102.269259, 21.847347 ], [ -102.269285, 21.8427 ], [ -102.256528, 21.843525 ], [ -102.255736, 21.843779 ], [ -102.256262, 21.842305 ], [ -102.256494, 21.841839 ], [ -102.256358, 21.840877 ], [ -102.255026, 21.840074 ], [ -102.25442, 21.839696 ], [ -102.254118, 21.839792 ], [ -102.253164, 21.840002 ], [ -102.251766, 21.840853 ], [ -102.251117, 21.841719 ], [ -102.250226, 21.843017 ], [ -102.249602, 21.843922 ] ] ] ] } }]
