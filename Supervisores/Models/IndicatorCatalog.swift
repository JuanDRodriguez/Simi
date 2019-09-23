//
//  IndicatorCatalog.swift
//  Supervisores
//
//  Created by Sharepoint on 7/11/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct CatalogIndicatorItem: Decodable {
    var IndicadorId: Int
    var Nombre: String
    var Grafica: Bool
    var Orden: Int
    var Visible: Bool
    var Agrupado: Bool
    var FechaInicio: String
    var FechaFin: String
    var Director: Bool
    var DirectorStaff: Bool
    var Gerente: Bool
    var Supervisor: Bool
    var Franquiciatario:Bool
    var FormatoIndicador: FormatterIndicator
    var Umbrales: [UmbralItem]?
}
struct FormatterIndicator: Decodable {
    var FormatoIndicadorId: Int
    var Simbolo: String
    var Decimal: Int
    var Activo: Bool
}
struct UmbralItem: Decodable {
   var UmbralId: Int?
    var Activo: Bool?
    var ValorMinimo: Double?
    var ValorMaximo: Double?
    var Color: String?
    var IndicadorId: Int?
    var Division: String?
}

class IndicatorCatalog {
    static let shared = IndicatorCatalog()
    var Catalogue: [CatalogIndicatorItem] = []
    func setCatalog()  {
        NetworkingServices.shared.getCatalog(){
             [unowned self] in
            
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
               // print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
            do{
                
            self.Catalogue = try JSONDecoder().decode([CatalogIndicatorItem].self, from: dataResponse)
                let array  = self.Catalogue.filter({$0.IndicadorId == 23 || $0.IndicadorId == 24 || $0.IndicadorId == 25 || $0.IndicadorId == 26 })
               
            }
            catch let error{
                print("ErrorLoadCatalogue\(error.localizedDescription)")
            }
        }
    }
    
    
}
