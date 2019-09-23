//
//  BreachLevelViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 29/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysBreachLevel: String {
    case id = "breachLevelId"
    case name = "breachLevelName"
    case active = "breachLevelActive"
}

@objc protocol BreachLevelVMProtocol {
    func getBreachError(error: Error)
    func getBreachLevel(levels: [[String: Any]])
}

class BreachLevelViewModel {
    static let shared = BreachLevelViewModel()
    var breachLevels : [BreachLevel] = []
    var listener: BreachLevelVMProtocol?
    init() { }
    
    func setListener(listener: BreachLevelVMProtocol?) {
        self.listener = listener
    }
    
    func getBreachesLevel() {
        if self.breachLevels.count > 0{
            self.listener?.getBreachLevel(levels: self.breachesToArray())
            return
        }
        NetworkingServices.shared.getBreachLevel() {
            [unowned self] in            
            if let error = $1 {
                self.reportErrorToListeners(error: error)
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.reportErrorToListeners(error: error)
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
               // print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError.localizedDescription)
            }
            do {
                let decoder = JSONDecoder()
                self.breachLevels = try decoder.decode([BreachLevel].self, from: data)
                self.listener?.getBreachLevel(levels: self.breachesToArray())
            } catch let error {
                print("ERROR DECODEO ===>> \(error)")
                self.reportErrorToListeners(error: error)
            }
        }
    }
    
    func breachesToArray()->[[String: Any]] {
        var arrayBreaches : [[String : Any]] = []
        for breach in self.breachLevels {
            if breach.active {
                let dicto : [String: Any] = [KeysBreachLevel.id.rawValue: breach.id,
                                             KeysBreachLevel.name.rawValue: breach.name,
                                             KeysBreachLevel.active.rawValue: breach.active]
                arrayBreaches.append(dicto)
            }
        }
        return arrayBreaches
    }
    
    func reportErrorToListeners(error: Error) {
        self.listener?.getBreachError(error: error)
    }
}
