//
//  MapViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 17/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import MapKit

enum KeysBrick: String {
    case arrayCoordinates = "arrayCoordinates"
    case topLeft = "topLeft"
    case topRight = "topRight"
    case bottomRight = "bottomRight"
    case bottomLeft = "bottomLeft"
    case maxDistnce = "maxDistance"
    case name = "name"
    case totalMarket = "totalMarket"
    case state = "state"
    case participation = "participation"
    case chance = "chance"
    case town = "town"
    case color = "color"
    case centerBlock = "centerBlock"
}

protocol BricksVMProtocol {
    func bricksLoaded(bricks: [[String: Any]])
}

class BricksViewModel {
    let listener: BricksVMProtocol
    var arrayBlocks: [Block] {
        didSet {
            var arrayBlockMaped: [[String: Any]] = []
            for block in self.arrayBlocks{
                arrayBlockMaped.append(blockToDictionary(block: block))
            }
            self.listener.bricksLoaded(bricks: arrayBlockMaped)
        }
    }
    
    func blockToDictionary(block: Block)->[String: Any]{
        let arrayCoordinate = block.geometry.coordinates.first!.first
        var arrayCoordinates : [CLLocationCoordinate2D] = []
        for coordinate in arrayCoordinate! {
            let lat = getCoordinateValue(coordinate: coordinate[1])
            let lng = getCoordinateValue(coordinate: coordinate[0])
            arrayCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        }
        let (topLeft, topRight, bottomRight, bottomLeft) = getCorners(block: block, margin: 0.0)
        let pointsToCheck = [topLeft, topRight, bottomLeft, bottomRight]
        if block.geometry.maxDistance == nil{ block.geometry.maxDistance = 0.0 }
        for point in pointsToCheck{
            let distance = point.distance(from: CLLocationCoordinate2D(latitude: block.geometry.centerBlock.0, longitude: block.geometry.centerBlock.1))
            if distance > block.geometry.maxDistance! {
                block.geometry.maxDistance = distance
            }
        }
        let colorBlock = block.properties.color ?? UIColor.black
        
        let blockDicto: [String : Any] = [KeysBrick.arrayCoordinates.rawValue: arrayCoordinates,
                                          KeysBrick.topLeft.rawValue: topLeft,
                                          KeysBrick.topRight.rawValue: topRight,
                                          KeysBrick.bottomRight.rawValue: bottomRight,
                                          KeysBrick.bottomLeft.rawValue: bottomLeft,
                                          KeysBrick.maxDistnce.rawValue: block.geometry.maxDistance ?? 0.0,
                                          KeysBrick.state.rawValue: block.properties.state,
                                          KeysBrick.participation.rawValue: block.properties.participationBrick,
                                          KeysBrick.chance.rawValue: block.properties.chanceBrick,
                                          KeysBrick.name.rawValue: block.properties.name,
                                          KeysBrick.totalMarket.rawValue: block.properties.totalMarket,
                                          KeysBrick.town.rawValue: block.properties.town,
                                          KeysBrick.color.rawValue: colorBlock,
                                          KeysBrick.centerBlock.rawValue: block.geometry.centerBlock]        
        return blockDicto
    }
    
    func getCoordinateValue(coordinate : Coordinates) -> Double{
        switch coordinate {
        case .double(let double): return double
        }
    }
    
    func getCorners(block: Block, margin: Double) -> (CLLocationCoordinate2D,CLLocationCoordinate2D,CLLocationCoordinate2D,CLLocationCoordinate2D){
        let topLeft = CLLocationCoordinate2D(latitude: block.geometry.topLat - margin, longitude: block.geometry.westLong + margin)
        let topRight = CLLocationCoordinate2D(latitude: block.geometry.topLat - margin, longitude: block.geometry.eastLong - margin)
        let bottomLeft = CLLocationCoordinate2D(latitude: block.geometry.bottomLat + margin, longitude: block.geometry.westLong + margin)
        let bottomRight = CLLocationCoordinate2D(latitude: block.geometry.bottomLat + margin, longitude: block.geometry.eastLong - margin)
        return (topLeft, topRight, bottomRight, bottomLeft)
    }
    
    init(_ listener: BricksVMProtocol) {
        self.listener = listener
        self.arrayBlocks = []
    }
    
    func parseJSONTest(data: Data)->Bricks?{
        do {
            let decoder = JSONDecoder()
            let test = try decoder.decode(Bricks.self, from: data)
            return test
        } catch let error {
            print("ERROR TEST===> \(error)")
            return nil
        }
    }
    func loadBricks(){
        DispatchQueue.global().async { [weak self] in
            if let path = Bundle.main.path(forResource: "blocks", ofType: "geojson") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let dataParsed = self?.parseJSONTest(data : data)
                    guard let arrayBlocks = dataParsed?.features else { return }
                    self?.arrayBlocks = arrayBlocks
                } catch {
                    // handle error
                }
            }
        }
    }
}
