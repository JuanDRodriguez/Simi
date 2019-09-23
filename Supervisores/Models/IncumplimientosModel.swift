//
//  IncumplimientosModel.swift
//  Supervisores
//
//  Created by Sharepoint on 8/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
class IncumplimientoModel {
    static let shared: IncumplimientoModel = IncumplimientoModel()
    var items: [Incumplimientositem] = []
    func load(){
        NetworkingServices.shared.getIncumplimientos(){
            [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError)
            }
            do{
                self.items = try JSONDecoder().decode([Incumplimientositem].self, from: dataResponse)
               
            }
            catch let error{
                
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
}
