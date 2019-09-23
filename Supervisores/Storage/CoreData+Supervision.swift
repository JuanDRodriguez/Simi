//
//  CoreData+Supervision.swift
//  Supervisores
//
//  Created by Sharepoint on 05/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct SupervisionData {
    var idUnit: Int
    var unitName: String
    var typeUnit: String
    var supervisorKey: String
    var statusUnit: Int32
    var nameSupervisor: String
    var domainAccount: String
    var completion: Bool
    var dateStart: Date?
}

extension CoreDataStorage {
    func startSupervision(supervisionData: SupervisionData)->Bool{
        if self.getCurrentSupervision(idUnit: supervisionData.idUnit) != nil {
            return false
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let manageContext = appDelegate.persistentContainer.viewContext
        let supervision = ResponseSupervision(context: manageContext)
        
        supervision.idUnit = Int32(supervisionData.idUnit)
        supervision.dateStart = Date()
        supervision.complete = false
        supervision.unitName = supervisionData.unitName
        supervision.typeUnit = supervisionData.typeUnit
        supervision.supervisorKey = supervisionData.supervisorKey
        supervision.statusUnit = supervisionData.statusUnit
        supervision.nameSupervisor = supervisionData.nameSupervisor
        supervision.domainAccount = supervisionData.domainAccount
        
        do {
            try manageContext.save()
        } catch {
            print("ERROR AL GUARDAR!!!! \(error)")
        }
        return true
    }
    func completeCurrentSupervision() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSupervision.rawValue)
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                let objectUpdate = test[0] as! ResponseSupervision
                objectUpdate.complete = true
                do {
                    try manageContext.save()
                } catch {
                    print("ERROR AL ACTUALIZAR!!!! \(error)")
                }
            }
        } catch {
            print("ERROR AL ACTUALIZAR!!!! \(error)")
        }
    }
    func getCurrentSupervision()->(SupervisionData) {
        let sup = SupervisionData(idUnit: 0,
                                  unitName: "",
                                  typeUnit: "",
                                  supervisorKey: "",
                                  statusUnit: 1,
                                  nameSupervisor: "",
                                  domainAccount: "",
                                  completion:  false,
                                  dateStart: nil)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return sup }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSupervision.rawValue)
        do {
            
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let supervision = test[0] as? ResponseSupervision {
                    let sup = SupervisionData(idUnit: Int(supervision.idUnit),
                                              unitName: supervision.unitName ?? "",
                                              typeUnit: supervision.typeUnit ?? "",
                                              supervisorKey: supervision.supervisorKey ?? "",
                                              statusUnit: supervision.statusUnit,
                                              nameSupervisor: supervision.nameSupervisor ?? "",
                                              domainAccount: supervision.domainAccount ?? "",
                                              completion: supervision.complete,
                                              dateStart: supervision.dateStart)
                    
                    return sup
                }
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return sup
    }
    func getCurrentSupervision(idUnit: Int)->ResponseSupervision?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSupervision.rawValue)
        moduleRequest.predicate = NSPredicate(format: "idUnit == \(idUnit)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let supervision = test[0] as? ResponseSupervision {
                    return supervision
                }
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return nil
    }
    
}
