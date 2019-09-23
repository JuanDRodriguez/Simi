//
//  EncuestasModel.swift
//  Supervisores
//
//  Created by Sharepoint on 8/29/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct scoreItem {
    var id: Int
    var count: Int
}
class EncuestasModel{
    static let shared: EncuestasModel = EncuestasModel()
    var out: EncuestasModelOutput!
    var items: [EncuestasItem] = []{
        didSet{
          
        }
    }
    var counts: [Int] = []
    var newEncuestas = 0
    var Score: [[String: Int]] = []
    func load(){
        NetworkingServices.shared.getEncuestas(){
            [unowned self] in
            
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                
            }
            do{
                let items  = try JSONDecoder().decode([EncuestasItem].self, from: dataResponse)
                
                self.items = self.getViableEncuestas(items: items.filter({$0.EstatusEncuesta?.Estatus == "Publicada"}))
                //let aux = self.setNumberEncuestas(items: self.items)
            }
            catch let error{
                
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
        }
    func setNumberEncuestas(items: [EncuestasItem]) -> ([EncuestasItem],[String:Int]){
        return (items,[:])
    }
    func setRestEncuestas(items: [EncuestasItem]) -> ([EncuestasItem],[String:Int]){
        let encuestas =  Storage.shared.getEncuestas(idUnit: 0)
        var uptadeItems: [EncuestasItem] = []
        var counts: [String:Int] = [:]
        for item in items{
            var existing = false
            var count = 0
            for encuesta in encuestas{
                if item.EncuestaId == encuesta.idEncuesta{
                    count = encuesta.count
                    existing = true
                }
            }
            counts["\(item.EncuestaId!)"] = count
            
            if !existing || count == 0{
                uptadeItems.append(item)
            }
        }
        self.newEncuestas = uptadeItems.count
        for item in uptadeItems{
            Storage.shared.updateEncuestas(item: item, count: 0)
        }
        return (items,counts)
    }
    func getViableEncuestas(items: [EncuestasItem]) -> [EncuestasItem]{
        
        
        return items.filter({Utils.isVisibleEncuesta(inicio: Utils.dateFromService(stringDate: $0.FechaInicio!), fin: Utils.dateFromService(stringDate: $0.FechaTermino!))})
    }
    func getScore() {
        NetworkingServices.shared.getScore(id:(LoginViewModel.shared.loginInfo?.user?.domainAccount)!){
            [unowned self] in
        
        guard let dataResponse = $0,
            $1 == nil else {
                print($1?.localizedDescription ?? "Response Error")
                
                return }
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with:
            dataResponse, options: []) as! [String:Int]
            print(jsonResponse) //Response result
            self.Score.append( jsonResponse)
            self.out.modelDidLoad((self.items,jsonResponse))
        } catch let parsingError {
            
        }
        do{
           
        }
        catch let error{
            
            print("ErrorDescription\(error.localizedDescription)")
        }
    }
    }
}
