//
//  CoreData+Encuestas.swift
//  Supervisores
//
//  Created by Sharepoint on 9/4/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import CoreData
struct MensajeStoreItem {
    var idMensaje: Int?
    var asunto: String
    var mensaje:String
    var fechaResgistro: String
    init(idMensaje: Int,asunto: String,mensaje: String,fechaRegistro: String) {
        self.idMensaje = idMensaje
        self.asunto = asunto
        self.mensaje = mensaje
        self.fechaResgistro = fechaRegistro
    }
    
}
extension CoreDataStorage{
    func getEncuestas() -> [EncuestaStoreItem]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Encuestas")
      
        do {
            var notas: [EncuestaStoreItem] = []
            let aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
            
            if aux.count > 0 {
                for nota in aux {
                   notas.append(EncuestaStoreItem.init(idEncuesta: nota.value(forKey: "idEncuesta") as! Int, dateEnd: nota.value(forKey: "dateEnd") as! String, instrucciones: nota.value(forKey: "instrucciones") as! String, nombre: nota.value(forKey: "nombre") as! String, destinatario:  nota.value(forKey: "destinatario") as! String, count:  nota.value(forKey: "count") as! Int))
                }
            }
            
            return notas
        } catch  {
            return []
        }
       
    }
    func updateEncuestas(items: EncuestasItem,count: Int) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Encuestas")
            moduleRequest.predicate = NSPredicate(format: "idEncuesta == \(items.EncuestaId!)")
            do {
                var aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
                if aux.count > 0{
                    aux = aux.filter({ $0.value(forKey: "idEncuesta") as! Int == items.EncuestaId })
                    
                    if aux.count > 0 {
                       aux[0].setValue(items.Nombre, forKey: "nombre")
                        aux[0].setValue(items.DESTINATARIO, forKey: "destinatario")
                        aux[0].setValue(items.FechaTermino, forKey: "dateEnd")
                        aux[0].setValue(items.Instrucciones?.Instrucciones, forKey: "Instrucciones")
                        aux[0].setValue(count, forKey: "count")
                        
                        try manageContext.save()
                    }else{
                     self.saveEncuesta(items: items)
                    }
                    
                }else{
                   self.saveEncuesta(items: items)
                }
            } catch {
                
            }
        }
    }
    func updateMensaje(item: MessageItem, count: Int) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Mensajes")
            moduleRequest.predicate = NSPredicate(format: "idMensaje == \(item.MensajeId!)")
            do {
                var aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
                if aux.count > 0{
                    aux = aux.filter({ $0.value(forKey: "idMensaje") as! Int == item.MensajeId})
                    
                    if aux.count > 0 {
                        aux[0].setValue(item.Mensaje, forKey: "mensaje")
                        aux[0].setValue(item.Asunto, forKey: "asunto")
                        aux[0].setValue(item.FechaEnvio, forKey: "fechaRegistro")
                        
                        try manageContext.save()
                    }else{
                          self.saveMensaje(item: item)
                    }
                    
                }else{
                     self.saveMensaje(item: item)
                }
            } catch {
                
            }
        }
    
    }
    func saveEncuesta(items: EncuestasItem){
        DispatchQueue.main.async {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Encuestas", in: context)
            let notaContext = NSManagedObject(entity: entity!, insertInto: context)
           
            
            do {
                notaContext.setValue(items.EncuestaId!, forKey: "idEncuesta")
                notaContext.setValue(0, forKey: "count")
                notaContext.setValue(items.FechaTermino!, forKey: "dateEnd")
                notaContext.setValue(items.DESTINATARIO!
                    , forKey: "destinatario")
                notaContext.setValue(items.Nombre!
                    , forKey: "nombre")
                notaContext.setValue(items.Instrucciones?.Instrucciones!
                    , forKey: "instrucciones")
                
                
                
                try context.save()
                
            } catch let error as Error {
                print("Error al crear \(error.localizedDescription)")
            }
        }
    }
    func saveMensaje(item: MessageItem){
        DispatchQueue.main.async {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Mensajes", in: context)
            let notaContext = NSManagedObject(entity: entity!, insertInto: context)
            
            
            do {
                notaContext.setValue(item.MensajeId!, forKey: "idMensaje")
                notaContext.setValue(item.Mensaje!, forKey: "mensaje")
                notaContext.setValue(item.Asunto!, forKey: "asunto")
                notaContext.setValue(item.FechaRegistro!, forKey: "fechaRegistro")
                
                try context.save()
                
            } catch let error as Error {
                print("Error al crear \(error.localizedDescription)")
            }
        }
    }
    func getMensajes() -> [MensajeStoreItem] {
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Mensajes")
        
        do {
            var notas: [MensajeStoreItem] = []
            let aux = try manageContext.fetch(moduleRequest) as! [NSManagedObject]
            
            if aux.count > 0 {
                for nota in aux {
                    notas.append(MensajeStoreItem.init(idMensaje: nota.value(forKey: "idMensaje") as! Int, asunto: nota.value(forKey: "asunto") as! String, mensaje: nota.value(forKey: "mensaje") as! String, fechaRegistro: nota.value(forKey: "fechaRegistro") as! String))
                }
            }
            
            return notas
        } catch  {
            return []
        }
    }
    
}
