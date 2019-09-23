//
//  CoreData+Pause.swift
//  Supervisores
//
//  Created by Sharepoint on 11/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension CoreDataStorage {
    func saveNewPause(idReason: Int, descReason: String){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let responsePause = ResponsePause(context: manageContext)
            responsePause.reasonId = Int16(idReason)
            responsePause.reasonDescription = descReason
            responsePause.dateStart = Date()
            do {
                try manageContext.save()
                print("GUARDO PAUSA!!!!")
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
    func updateLastPause(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePause.rawValue)
        do {
            let arrayPauses = try manageContext.fetch(moduleRequest)
            for pause in arrayPauses as! [ResponsePause] {
                if pause.dateEnd == nil {
                    pause.dateEnd = Date()
                    do {
                        try manageContext.save()
                    } catch {
                        print("ERROR AL GUARDAR!!!! \(error)")
                    }
                    
//                    return
                }
            }
        } catch {
            print("ERROR AL OBTENER PAUSAS!!!! \(error)")
        }
    }
    func getPauses()->[PauseSupervision]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePause.rawValue)
        do {
            let arrayPauses = try manageContext.fetch(moduleRequest) as! [ResponsePause]
            let pauses:[PauseSupervision] = arrayPauses.map({
                let pause = PauseSupervision(pauseId: Int($0.reasonId), pauseDescriptionId: $0.reasonDescription ?? "", dateStart: $0.dateStart, dateEnd: $0.dateEnd)
                return pause
            })
           return pauses
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return []
    }
}
