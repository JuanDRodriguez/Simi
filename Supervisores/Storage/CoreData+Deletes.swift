//
//  CoreData+Deletes.swift
//  Supervisores
//
//  Created by Sharepoint on 14/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension CoreDataStorage {
    func deleteResponseBreach(isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseBreach.rawValue)
            do {
                let modules = try manageContext.fetch(moduleRequest)
                for module in modules {
                    if let moduleObject = module as? NSManagedObject {
                        if isEditing {
                            if let moduleResponseBreach = module as? ResponseBreach {
                                if !moduleResponseBreach.isEditing {
                                    manageContext.delete(moduleObject)
                                }
                            }
                        } else  {
                            manageContext.delete(moduleObject)
                        }
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
    func deleteResponseModule(){
        DispatchQueue.main.async {
            SupervisionModulesViewModel.shared.resetModule()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseModule.rawValue)
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
    func deleteResponseOption(isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseQuestion.rawValue)
            do {
                let modules = try manageContext.fetch(moduleRequest)
                for module in modules {
                    if let moduleObject = module as? NSManagedObject {
                        if isEditing {
                            print("OPCION EDITADA")
                            if let moduleResponseOption = module as? ResponseOption {
                                if !moduleResponseOption.isEditing {
                                    manageContext.delete(moduleObject)
                                } else {
                                    print("ENCONTRO EDITADA")
                                }
                            }
                        } else  {
                            manageContext.delete(moduleObject)
                        }
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
    func deleteResponsePause(){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePause.rawValue)
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
    func deleteResponsePhoto(isEditing: Bool) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePhoto.rawValue)
            do {
                let modules = try manageContext.fetch(moduleRequest)
                for module in modules {
                    if let moduleObject = module as? NSManagedObject {
                        if isEditing {
                            if let moduleResponsePhoto = module as? ResponsePhoto {
                                if !moduleResponsePhoto.isEditing {
                                    manageContext.delete(moduleObject)
                                }
                            }
                        } else  {
                            manageContext.delete(moduleObject)
                        }
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
    func deleteResponseQuestion(isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseQuestion.rawValue)
            do {
                let modules = try manageContext.fetch(moduleRequest)
                for module in modules {
                    if let moduleObject = module as? NSManagedObject {
                        if isEditing {
                            if let moduleResponseOption = module as? ResponseQuestion{
                                if !moduleResponseOption.isEditing {
                                    manageContext.delete(moduleObject)
                                }
                            }
                        } else  {
                            manageContext.delete(moduleObject)
                        }
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
    func deleteResponseSuboption(isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSuboption.rawValue)
            do {
                let modules = try manageContext.fetch(moduleRequest)
                for module in modules {
                    if let moduleObject = module as? NSManagedObject {
                        if isEditing {
                            if let moduleResponseSuboption = module as? ResponseSuboption {
                                if !moduleResponseSuboption.isEditing {
                                    manageContext.delete(moduleObject)
                                }
                            }
                        } else  {
                            manageContext.delete(moduleObject)
                        }
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
    func deleteResponseSupervision(){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSupervision.rawValue)
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
    func updateResponseSupervision(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSupervision.rawValue)
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! ResponseSupervision
                objectUpdate.dateStart = Date()
                do {
                    try manageContext.save()
                } catch {
                    print("ERROR 1 AL ACTUALIZAR!!!! \(error)")
                }
            }
        } catch {
            print("ERROR AL ACTUALIZAR!!!! \(error)")
        }
    }
}
