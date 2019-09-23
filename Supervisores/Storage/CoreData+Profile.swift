//
//  CoreData+Profile.swift
//  Supervisores
//
//  Created by Sharepoint on 9/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import CoreData
extension CoreDataStorage{
    func getProfile() -> (Int, Int) {
       var current = 0
        var last = 0
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return (0,0) }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Perfil")
        do {
            var notas: [NotasItem] = []
            let aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
            
           
            if aux.count > 0{
               current =  aux[0].value(forKey: "currentProfile") as! Int
                last =  aux[0].value(forKey: "lastProfile") as! Int
            }
            
            return (current,last)
        } catch let error as Error  {
            print("Error al crear Profile \(error.localizedDescription)")
            return (0,0)
        }
    }
    func setProfile(currentProfile: Int, lastProfile: Int) {
        DispatchQueue.main.async {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Perfil", in: context)
            let notaContext = NSManagedObject(entity: entity!, insertInto: context)
            
            
            do {
                notaContext.setValue(currentProfile, forKey: "currentProfile")
                notaContext.setValue(lastProfile, forKey: "lastProfile")
                
                
                try context.save()
                
            } catch let error as Error {
                print("Error al crear Profile \(error.localizedDescription)")
            }
        }
    }
}
