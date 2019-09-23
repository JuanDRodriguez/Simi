//
//  CoreData+Private.swift
//  Supervisores
//
//  Created by Sharepoint on 04/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension CoreDataStorage {
    func getModule(idModule : Int)->ModuleStored? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.module.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(idModule)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if let module = test[0] as? ModuleStored {
                return module
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return nil
    }
    
    func getOptionStored(idOption : Int)->OptionStored? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.option.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(idOption)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let option = test[0] as? OptionStored {
                    return option
                }
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return nil
    }
}
