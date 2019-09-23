//
//  GeneralCloseModel.swift
//  Supervisores
//
//  Created by Sharepoint on 8/2/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct GeneralCloseItem: Decodable {
    var CierreGeneralId: Int
    var Activo: Bool
    var HoraInicio: String
    var HoraFin: String
    var FechaRegistro: String
    var FechaModificacion: String
}
class GeneralCloseModel{
    static let shared = GeneralCloseModel()
    var generalClose: GeneralCloseItem? = nil
    func load(){
        NetworkingServices.shared.getGeneralClose(){
            [unowned self] in
            
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError)
            }
            do{
               self.generalClose = try JSONDecoder().decode(GeneralCloseItem.self, from: dataResponse)
                
            }
            catch let error{
                
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
    
}
