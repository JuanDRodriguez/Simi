//
//  WeighingRangeViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 9/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

import Foundation

struct ScoreInfo {
    var stars: Int
    var description: String
    var legend: String
    var image: String
}

class WeighingRangeViewModel {
    static let shared = WeighingRangeViewModel()
    var weighingRangeFranchise = [WeighingRange]()
    var weighingRangeBranch = [WeighingRange]()
    private init() { }
    
    func getBrachInfo(value: Int, completion: @escaping (ScoreInfo?)->Void )->Bool {
        if !weighingRangeBranch.isEmpty {
            search(value: value, in: weighingRangeBranch, completion: completion)
            return true
        }
        getInfoFromServer(value: value, type: "s", completion: completion)
        return false
    }
    
    func getFranchiseInfo(value: Int, completion: @escaping (ScoreInfo?)->Void )->Bool {
        if !weighingRangeBranch.isEmpty {
            search(value: value, in: weighingRangeFranchise, completion: completion)
            return true
        }
        getInfoFromServer(value: value, type: "f", completion: completion)
        return false
    }
    
    private func search(value: Int,in array:[WeighingRange], completion: @escaping (ScoreInfo?)->Void) {
        //TO DO: SE OBTIENE LA INFO CON EL NUMERO DE ESTRELLAS, NO SE SI SEA CORRECTO, SI ES CON EL VALOR DE LA SUPERVISION NO SE DE DONDE SACARLO
        for weighingRange in array {
            //            if value >= weighingRange.minValue &&
            //                value <= weighingRange.maxValue {
            if value == weighingRange.stars {
                let scoreInfo = ScoreInfo(stars: weighingRange.stars,
                                          description: weighingRange.description,
                                          legend: weighingRange.legend,
                                          image: weighingRange.image)
                completion(scoreInfo)
            }
        }
        completion(nil)
    }
    
    private func getInfoFromServer(value: Int, type: String, completion: @escaping (ScoreInfo?)->Void ){
        NetworkingServices.shared.getWeighingRange(type: type) {
            [unowned self] in
            if let _ = $1 {
                completion(nil)
            }
            guard let data = $0 else {
                completion(nil)
                return
            }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
            do {
                let decoder = JSONDecoder()
                if type == "s" {
                    self.weighingRangeBranch = try decoder.decode([WeighingRange].self, from: data)
                    self.search(value: value, in: self.weighingRangeBranch, completion: completion)
                } else {
                    self.weighingRangeFranchise = try decoder.decode([WeighingRange].self, from: data)
                    self.search(value: value, in: self.weighingRangeFranchise, completion: completion)
                }
            } catch {
                completion(nil)
            }
        }
    }
}
