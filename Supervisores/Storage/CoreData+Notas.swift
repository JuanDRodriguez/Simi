//
//  CoreData+Notas.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//
import Foundation
import UIKit
import CoreData

extension CoreDataStorage {
    func saveNota(nota: NotasItem) {
        DispatchQueue.main.async {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Notas", in: context)
        let notaContext = NSManagedObject(entity: entity!, insertInto: context)
            let array = self.getAllNotas()
        
       do {
        notaContext.setValue(nota.idUnit, forKey: "idUnit")
        notaContext.setValue(array.count + 1, forKey: "idNota")
        notaContext.setValue(nota.title, forKey: "title")
        notaContext.setValue(nota.detail
            , forKey: "detail")
       
            try context.save()
            
        } catch let error as Error {
            print("Error al crear \(error.localizedDescription)")
        }
        }
    }
    func getNotas(idUnit: Int32) -> [NotasItem] {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notas")
         moduleRequest.predicate = NSPredicate(format: "idUnit == \(idUnit)")
        do {
            var notas: [NotasItem] = []
            let aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
            
            if aux.count > 0 {
                for nota in aux {
                   
                    notas.append(NotasItem.init(idNota: nota.value(forKey: "idNota") as! Int32, idUnit: nota.value(forKey: "idUnit") as! Int32, title: nota.value(forKey: "title") as! String, detail: nota.value(forKey: "detail") as! String))
                    
                  
                }
                }
            
            return notas
        } catch  {
           return []
        }
        
    }
    func updateNotas(nota: NotasItem) {
        DispatchQueue.main.async {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notas")
        moduleRequest.predicate = NSPredicate(format: "idUnit == \(nota.idUnit)")
        do {
             var aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
            if aux.count > 0{
                 aux = aux.filter({ $0.value(forKey: "idNota") as! Int32 == nota.idNota})
              
               if aux.count > 0 {
                aux[0].setValue(nota.title, forKey: "title")
                aux[0].setValue(nota.detail
                    , forKey: "detail")
                try manageContext.save()
               }else{
                self.saveNota(nota: nota)
                }
                
            }else{
               self.saveNota(nota: nota)
            }
        } catch {
            
        }
        }
    }
    
    func getAllNotas() -> [NSManagedObject]{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notas")
        do {
        let aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
            return aux
        } catch  {
            return []
        }
        return []
    }
    func deleteNota(nota: NotasItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notas")
        moduleRequest.predicate = NSPredicate(format: "idUnit == \(nota.idUnit) && idNota == \(nota.idNota)")
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
            print("ERROR AL OBTENER BREACH!!!! \(error)")
        }
    }
}

