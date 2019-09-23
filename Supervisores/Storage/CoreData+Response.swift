//
//  CoreData+Response.swift
//  Supervisores
//
//  Created by Sharepoint on 04/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension CoreDataStorage {
    func deleteCurrentSupervision(isEditing: Bool, creatingNewSupervision: Bool) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let supervisionRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSupervision.rawValue)
            do {
                let supervisions = try manageContext.fetch(supervisionRequest)
                for supervision in supervisions {
                    if let supervisionObject = supervision as? NSManagedObject {
                        manageContext.delete(supervisionObject)
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
//            if !creatingNewSupervision {
                CurrentSupervision.shared.setCurrentUnit(unit: [:])
//            }
            CurrentSupervision.shared.setCurrentModule(module: [:])
            QuestionViewModel.shared.resetQuestions()
            
            self.resetSuboptions(isEditing: isEditing)
            self.deleteResponsePause()
            self.deleteResponsePhoto(isEditing: isEditing)
            self.deleteResponseBreach(isEditing: isEditing)
            self.deleteResponseModule()
            self.deleteResponseOption(isEditing: isEditing)
            self.deleteResponseQuestion(isEditing: isEditing)
            self.deleteResponseSuboption(isEditing: isEditing)
//            if !creatingNewSupervision {
                self.deleteResponseSupervision()
//            } else {
//                self.updateResponseSupervision()
//            }
            if !isEditing {
                self.deleteModules()
            }
        }
    }
    func resetSuboptions(isEditing: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSuboption.rawValue)
        do {
            let suboptions = try manageContext.fetch(moduleRequest) as! [ResponseSuboption]
            for suboption in suboptions {
                if isEditing {
                    if !suboption.isEditing {
                        suboption.answerSuboption = ""
                    }
                } else  {
                    suboption.answerSuboption = ""
                }
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
    func getResponseModule(idModule: Int32)->ResponseModule? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseModule.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(idModule)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let module = test[0] as? ResponseModule {
                    return module
                }
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return nil
    }
    func getResponseQuestion(idQuestion: Int)->ResponseQuestion? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseQuestion.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(Int32(idQuestion))")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let question = test[0] as? ResponseQuestion {
                    return question
                }
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return nil
    }
    func getResponseOption(idOption: Int32)->ResponseOption? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseOption.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(idOption)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let option = test[0] as? ResponseOption {
                    
                    
                    return option
                }
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return nil
    }
    func updateResponseModule(module:Module) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseModule.rawValue)
            moduleRequest.predicate = NSPredicate(format: "id == \(module.id)")
            do {
                let test = try manageContext.fetch(moduleRequest)
                if test.count > 0 {
                    let objectUpdate = test[0] as! ResponseModule
                    objectUpdate.currentQuestion = Int32(module.currentQuestion)
                    objectUpdate.percentFinish = Int32(module.percentFinish)
                    do {
                        try manageContext.save()
                    } catch {
                        print("ERROR 1 AL ACTUALIZAR!!!! \(error)")
                    }
                } else {
                    self.createResponseModule(module: module)
                }
                
            } catch {
                print("ERROR AL ACTUALIZAR!!!! \(error)")
            }
        }
    }
    func createResponseModule(module: Module){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let responseModule = ResponseModule(context: manageContext)
            responseModule.id = Int32(module.id)
            responseModule.currentQuestion = Int32(module.currentQuestion)
            responseModule.percentFinish = Int32(module.percentFinish)
            if let idUnit = CurrentSupervision.shared.getCurrentUnit()[KeysQr.unitId.rawValue] as? Int {
                responseModule.supervision = self.getCurrentSupervision(idUnit: idUnit)
            }
            do {
                try manageContext.save()
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
    func updateResponseQuestion(question: Question, isEditing: Bool){
        question.photos = []
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let breachRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseQuestion.rawValue)
            breachRequest.predicate = NSPredicate(format: "id == \(question.id)")
            do {
                let test = try manageContext.fetch(breachRequest)
                if test.count > 0 {
                    let objectUpdate = test[0] as! ResponseQuestion
                    objectUpdate.action = question.actionDescription
                    objectUpdate.comment = question.commentDescripton
                    if let actionId = question.actionId {
                        objectUpdate.idAction = Int16(actionId)
                    }
                    objectUpdate.breachFinish = question.breachEnd ?? false
                    objectUpdate.isEditing = isEditing
                    objectUpdate.dateSolutionCommon = question.dateSolutionCommon
                    objectUpdate.hasBreach = question.hasBreach ?? false
                    do {
                        try manageContext.save()
                    } catch {
                        print("ERROR 1 AL ACTUALIZAR!!!! \(error)")
                    }
                } else {
                    self.createResponseQuestion(question: question, isEditing: isEditing)
                }
            } catch {
                print("ERROR AL ACTUALIZAR!!!! \(error)")
            }
        }
    }
    func createResponseQuestion(question: Question, isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let responseQuestion = ResponseQuestion(context: manageContext)
            responseQuestion.id = Int32(question.id)
            responseQuestion.action = question.actionDescription
            responseQuestion.isEditing = isEditing
            if let actionId = question.actionId {
                responseQuestion.idAction = Int16(actionId)
            }
            responseQuestion.comment = question.commentDescripton
            responseQuestion.hasBreach = question.hasBreach ?? false
            responseQuestion.breachFinish = question.breachEnd ?? false
            responseQuestion.dateSolutionCommon = question.dateSolutionCommon
            responseQuestion.module = self.getResponseModule(idModule: Int32(question.moduleId))
            do {
                try manageContext.save()
            } catch {
                
            }
        }
    }
    func updateResponseBreach(breach: Breach, optionId: Int, isEditing: Bool){
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let breachRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseBreach.rawValue)
            breachRequest.predicate = NSPredicate(format: "id == \(breach.id)")
            do {
                let test = try manageContext.fetch(breachRequest)
                if test.count > 0 {
                    let objectUpdate = test[0] as! ResponseBreach
                    objectUpdate.dateSolution = breach.breachDate
                    objectUpdate.levelBreach = breach.breachLevel
                    objectUpdate.selected = breach.breachSelected
                    objectUpdate.levelBreachId = Int16(breach.breachLevelId)
                    objectUpdate.isEditing = isEditing
                    do {
                        try manageContext.save()
                    } catch {
                        print("ERROR 1 AL ACTUALIZAR!!!! \(error)")
                    }
                } else {
                    self.createResponseBreach(breach: breach, optionId: optionId, isEditing: isEditing)
                }
            } catch {
                print("ERROR AL ACTUALIZAR!!!! \(error)")
            }
        }
    }
    
    func createResponseBreach(breach: Breach, optionId: Int, isEditing: Bool){
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let responseBreach = ResponseBreach(context: manageContext)
            responseBreach.dateSolution = breach.breachDate
            responseBreach.selected = breach.breachSelected
            responseBreach.id = Int32(breach.id)
            responseBreach.levelBreach = breach.breachLevel
            responseBreach.levelBreachId = Int16(breach.breachLevelId)
            responseBreach.option = self.getResponseOption(idOption: Int32(optionId))
            responseBreach.isEditing = isEditing
            do {
                try manageContext.save()
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
    func updateOptionResponse(option: OptionQuestion, idQuestion: Int, isEditing: Bool) {
        print("GUARDANDO OPCION CON EDIT ==>>>> \(isEditing)")
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let breachRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseOption.rawValue)
            breachRequest.predicate = NSPredicate(format: "id == \(option.id)")
            do {
                let test = try manageContext.fetch(breachRequest)
                if test.count > 0 {
                    let objectUpdate = test[0] as! ResponseOption
                    objectUpdate.selected = option.isSelected
                    objectUpdate.isEditing = isEditing
                    do {
                        try manageContext.save()
                    } catch {
                        print("ERROR 1 AL ACTUALIZAR!!!! \(error)")
                    }
                } else {
                    self.createOptionResponse(option: option, idQuestion: idQuestion, isEditing: isEditing)
                }
            } catch {
                print("ERROR AL ACTUALIZAR!!!! \(error)")
            }
        }
    }
    func createOptionResponse(option: OptionQuestion, idQuestion: Int, isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let responseOption = ResponseOption(context: manageContext)
            responseOption.id = Int32(option.id)
            responseOption.idQuestion = Int32(idQuestion)
            responseOption.selected = option.isSelected
            responseOption.isEditing = isEditing
            responseOption.question = self.getResponseQuestion(idQuestion: idQuestion)
            do {
                try manageContext.save()
            } catch {
            }
        }
    }
    func savePhoto(photo: String, position: Int, questionId: Int, isEditing: Bool){
        print("GUARDANDO PHOTO CON EDIT ==>>>> ")
        DispatchQueue.main.async {
            if self.photoExist(position: position, questionId: questionId) {
                self.updatePhoto(position: position, questionId: questionId, photoUpdated: photo, isEditing: isEditing)
            }
            else {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let manageContext = appDelegate.persistentContainer.viewContext
                let responsePhoto = ResponsePhoto(context: manageContext)
                responsePhoto.photo = photo
                responsePhoto.idQuestion = Int32(questionId)
                responsePhoto.position = Int16(position)
                responsePhoto.isEditing = isEditing
                responsePhoto.question = self.getResponseQuestion(id: Int32(questionId))
                do {
                    try manageContext.save()
                   
                    
                } catch {
                    print("ERROR AL GUARDAR!!!! \(error)")
                }
            }            
        }
        
    }
    func deletePhoto(position: Int, questionId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePhoto.rawValue)
        moduleRequest.predicate = NSPredicate(format: "idQuestion == \(questionId) && position == \(position)")
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
    func photoExist(position: Int, questionId: Int)->Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePhoto.rawValue)
        moduleRequest.predicate = NSPredicate(format: "idQuestion == \(questionId) && position == \(position)")
        do {
            let modules = try manageContext.fetch(moduleRequest)
            if modules.count > 0 {
                return true
            }
        } catch {
            print("ERROR AL OBTENER PHOTO!!!! \(error)")
        }
        return false
    }
    func updatePhoto(position: Int, questionId: Int, photoUpdated: String, isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePhoto.rawValue)
            moduleRequest.predicate = NSPredicate(format: "idQuestion == \(questionId) && position == \(position)")
            do {
                let photos = try manageContext.fetch(moduleRequest)
                let photo = photos[0] as! ResponsePhoto
                photo.isEditing = isEditing
                photo.photo = photoUpdated
                do {
                    try manageContext.save()
                } catch {
                    print("ERROR 1 AL ACTUALIZAR!!!! \(error)")
                }
            } catch {
                print("ERROR AL OBTENER PHOTO!!!! \(error)")
            }
        }
    }
    func updateSuboption(suboption: SubOption, optionId: Int, isEditing: Bool){
        print("update suboption ==>>> \(isEditing)")
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let subotionRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseSuboption.rawValue)
            subotionRequest.predicate = NSPredicate(format: "id == \(suboption.id)")
            do {
                let test = try manageContext.fetch(subotionRequest)
                if test.count > 0 {
                    let objectUpdate = test[0] as! ResponseSuboption
                    objectUpdate.answerSuboption = suboption.answer
                    objectUpdate.isEditing = isEditing
                    do {
                        try manageContext.save()
                    } catch {
                        print("ERROR 1 AL ACTUALIZAR!!!! \(error)")
                    }
                } else {
                    self.createSuboption(suboption: suboption, optionId: optionId, isEditing: isEditing)
                }
            } catch {
                print("ERROR AL ACTUALIZAR!!!! \(error)")
            }
        }
    }
    func createSuboption(suboption: SubOption, optionId: Int, isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let responseSuboption = ResponseSuboption(context: manageContext)
            responseSuboption.id = Int32(suboption.id)
            responseSuboption.descriptionSuboption = suboption.description
            responseSuboption.answerSuboption = suboption.answer
            responseSuboption.active = suboption.active
            responseSuboption.isEditing = isEditing
            responseSuboption.suboptionId = Int32(suboption.idSuboption)
            responseSuboption.option = self.getOptionStored(idOption: optionId)
            do {
                try manageContext.save()
                 print("create suboption ==>>> \(isEditing)")
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
}
