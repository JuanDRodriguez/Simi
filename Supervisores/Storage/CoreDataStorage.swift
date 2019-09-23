//
//  CoreDataStorage.swift
//  Supervisores
//
//  Created by Sharepoint on 28/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum CoreDataEntities: String {
    case module = "ModuleStored"
    case question = "QuestionStored"
    case option = "OptionStored"
    case breach = "BreachStored"
    
    case responseOption = "ResponseOption"
    case responseBreach = "ResponseBreach"
    case responseModule = "ResponseModule"
    case responsePhoto = "ResponsePhoto"
    case responseQuestion = "ResponseQuestion"
    case responseSupervision = "ResponseSupervision"
    case responsePause = "ResponsePause"
    case responseSuboption = "ResponseSuboption"
}

class CoreDataStorage: StorageProtocol {
    func saveModules(listModules : [Module]) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            for module in listModules {
                let moduleS = ModuleStored(context: manageContext)
                moduleS.active = module.active
                moduleS.id = Int32(module.id)
                moduleS.image = module.image.pngData()
                moduleS.name = module.name
                moduleS.numberQuestions = Int32(module.numberQuestions)
                moduleS.type = module.type
                moduleS.order = Int32(module.order)
                moduleS.dateRegister = module.dateRegister
                moduleS.dateChange = module.dateChange
            }
            do {
                try manageContext.save()
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
    func getModules()->[Module] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.module.rawValue)
        var listModules : [Module] = []
        do {
            let modulesStored = try manageContext.fetch(moduleRequest)
            if let modulesMapped = modulesStored as? [ModuleStored] {
                listModules = modulesMapped.map({
                    let respModule = self.getResponseModule(idModule: $0.id)
                    if let respM = respModule {
                        return Module(module: $0, percentFinish: Int(respM.percentFinish), currentQuestion: Int(respM.currentQuestion))
                    }
                    else {
                        return Module(module: $0, percentFinish: 0, currentQuestion: 0)
                    }
                })
            }
        } catch {
            print("ERROR AL RECUPERAR!!!! \(error)")
        }
        return listModules
    }
    func deleteModules(){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.module.rawValue)
            do {
                let modules = try manageContext.fetch(moduleRequest)
                for module in modules {
                    if let moduleObject = module as? NSManagedObject {
                        manageContext.delete(moduleObject)
                    }
                }
                do {
                    try manageContext.save()
                } catch {
                    print("ERROR 1 AL BORRAR!!!! \(error)")
                }
            } catch {
                print("ERROR AL BORRAR!!!! \(error)")
            }
        }
    }
}
