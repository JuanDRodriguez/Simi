//
//  VisitModel.swift
//  Supervisores
//
//  Created by Sharepoint on 7/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class VisitModel: visitModelInput {
    
    var output: visitedModelOutput!
    var out: visitModelOutput!
    var json: [String : Any] = [:]
    var idUnit: Int!
    func load(date: Date) {
        
        NetworkingServices.shared.getReasons(){
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
                    let items = try JSONDecoder().decode([ReasonItem].self, from: dataResponse)
                    self.orderByTypeVisit(items: items)
                }
            catch let error{
                
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
    func loadVisited(idUnit: Int){
        self.idUnit = idUnit
        NetworkingServices.shared.getVisit(idUnit: idUnit){
            [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                dataResponse, options: []) as! [[String: Any]]
                print(jsonResponse)
                var items = [VisistItem]()//Response result
                for item in jsonResponse{
                    items.append(VisistItem.init(item))
                }
                self.output.modelDidLoad(items)
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }
    }
    func sendVisit(photos:PhotosView,motivos:[(Bool,Int)],comentario:String,date: (Date,Date)) {
        json["Comentario"] = comentario
        json["Motivos"] = getMotivosFromSelected(motivos: motivos)
        json["FechaInicio"] = Utils.stringFromDateService(date: date.0)
        json["FechaFin"] = Utils.stringFromDateService(date: date.1)
        let arrayPhotos = getImageFromPhotos(photos: photos)
    //print("TamañoArrayFotos: \(arrayPhotos.count)")
    if arrayPhotos.count > 0{
        self.getPhotos(photos: arrayPhotos, item: (self.idUnit,"Visita",Utils.stringFromDateNowName())){
           [unowned self] in
            if $0.count > 0{
        //print("\($0)")
            self.json["Fotografias"] = $0
            self.createVisist(json: self.json)
            }else{
                self.out.modelDidFail()
            }
        }
    }
    else{
        json["Fotos"] = []
        self.createVisist(json: self.json)
    }
    
    }
    
}
