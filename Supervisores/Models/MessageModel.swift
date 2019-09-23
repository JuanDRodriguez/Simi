//
//  MessageModel.swift
//  Supervisores
//
//  Created by Sharepoint on 9/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
class MessageModel {
    static let shared: MessageModel = MessageModel()
    var items: [MessageItem] = []{
        didSet{
            _ = self.setNumberMessage(items: self.items)
        }
    }
    var newMessages: Int = 0
    func load(){
        NetworkingServices.shared.getMessage(){
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
                
                print("Error", parsingError)
            }
            do{
                let items  = try JSONDecoder().decode([MessageItem].self, from: dataResponse)
                self.items = self.filterProfile(array: self.quickSort(array: items))
                
                
            }
            catch let error{
               
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
    func setNumberMessage(items: [MessageItem]) -> [MessageItem]{
        let messages = Storage.shared.getMensajes()
        var uptadeItems: [MessageItem] = []
        for item in items{
            var existing = false
            for message in messages{
                if item.MensajeId == message.idMensaje{
                    existing = true
                }
            }
            
            if !existing{
                uptadeItems.append(item)
            }
        }
        newMessages = uptadeItems.count
        for item in uptadeItems{
            Storage.shared.updateMensaje(item: item, count: 0)
        }
        return items
    }
    func filterProfile(array: [MessageItem]) -> [MessageItem]{
        if array.isEmpty { return [] }
        if User.currentProfile == .director{
           return array.filter({$0.Directores!})
        }
        if User.currentProfile == .manager{
            return array.filter({$0.Gerentes!})
        }
        if User.currentProfile == .supervisor{
             return array.filter({$0.Supervisores!})
        }
        return []
    }
    func quickSort(array: [MessageItem]) -> [MessageItem] {
        if array.isEmpty { return [] }
        
        let first = array.first!
        
        let smallerOrEqual = array.dropFirst().filter { Utils.dateFromService(stringDate: $0.FechaEnvio!) <= Utils.dateFromService(stringDate: $0.FechaEnvio!) }
        let larger         = array.dropFirst().filter { Utils.dateFromService(stringDate: $0.FechaEnvio!) > Utils.dateFromService(stringDate: $0.FechaEnvio!) }
        
        return quickSort(array: smallerOrEqual) + [first] + quickSort(array: larger)
    }
}
