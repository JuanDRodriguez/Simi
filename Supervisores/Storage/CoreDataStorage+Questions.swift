//
//  CoreDataStorage+Questions.swift
//  Supervisores
//
//  Created by Sharepoint on 01/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension CoreDataStorage {
    func getQuestions(module: Int) -> [Question] {
        guard let module = self.getModule(idModule: module) else { return [] }
        guard let questions = module.questions else { return [] }
        guard let questionsStored = questions.allObjects as? [QuestionStored] else { return [] }
       
        let listQuestions : [Question] = questionsStored.map({[unowned self] in
            let listOpc = self.getOptions(questionS: $0)
            let responseQuestion = self.getResponseQuestion(id: $0.id)
            let photos: [UIImage] = self.getPhotosQuestion(id: Int16($0.id)) ?? []
            let question = Question(questionS: $0, listOptions: listOpc, questionAnswer: responseQuestion, photos: photos)
            return question
        })
        return listQuestions
    }
    func getPhotosQuestion(id: Int16)->[UIImage]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responsePhoto.rawValue)
        moduleRequest.predicate = NSPredicate(format: "idQuestion == \(id)")
        do {
            if var storedPhotos = try manageContext.fetch(moduleRequest) as? [ResponsePhoto] {
                storedPhotos = storedPhotos.sorted(by: {$0.position < $1.position})
                var photos : [UIImage] = []
                for url in storedPhotos{
                    photos.append(try UIImage(withContentsOfUrl: URL(fileURLWithPath: url.photo!))! )
                }
               
            
                return photos
            }
        } catch {
            print("ERROR AL OBTENER BREACH!!!! \(error)")
        }
        return nil
    }
    func getOptions(questionS: QuestionStored)->[OptionQuestion]{
        var listOpc:[OptionQuestion] = []
        if let setOpc = questionS.options?.allObjects as? [OptionStored] {
            listOpc = setOpc.map({[unowned self ] in
                let listBreach = self.getBreaches(option: $0)
                let listMails = self.getMails(option: $0)
                let listSuboptions = self.getSuboptions(option: $0)
                if let respOption = self.getResponseOption(idOption: $0.id) {
                    let option = OptionQuestion(optionS: $0, listBreach: listBreach, selected: respOption.selected, mails: listMails, suboptions: listSuboptions)
                    return option
                }
                let option = OptionQuestion(optionS: $0, listBreach: listBreach, selected: false, mails: listMails, suboptions: listSuboptions)
                return option
            })
        }
        return listOpc
    }
    func getSuboptions(option: OptionStored)->[SubOption] {
        var listSuboptions : [SubOption] = []
        if let setSuboptions = option.suboptions?.allObjects as? [ResponseSuboption] {
            listSuboptions = setSuboptions.map({
                let suboption = SubOption(optionS: $0)
                return suboption
            })
        }
        return listSuboptions
    }
    func getMails(option: OptionStored)->[OptionMail] {
        var listMails : [OptionMail] = []
        if let setMails = option.mails?.allObjects as? [MailStored] {
            listMails = setMails.map({
                let mail = OptionMail(email: $0.mail ?? "")
                return mail
            })
        }
        return listMails
    }
    func getBreaches(option: OptionStored)->[Breach]{
        var listBreach : [Breach] = []
        if let setBreach = option.breaches?.allObjects as? [BreachStored] {
            listBreach = setBreach.map({ [unowned self] in
                if let responseBreach = self.getResponseBreach(id: $0.id) {
                    let breach = Breach(breachS: $0, breachLevel: responseBreach.levelBreach ?? "", breachLevelId : Int(responseBreach.levelBreachId), breachLevelSelected: responseBreach.selected , breachDate: responseBreach.dateSolution)
                    return breach
                } else {
                    let breach = Breach(breachS: $0, breachLevel: "", breachLevelId : -1)
                    return breach
                }
            })
        }
        return listBreach
    }
    func getResponseBreach(id: Int32)->ResponseBreach?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseBreach.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(id)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let breach = test[0] as? ResponseBreach {
                    return breach
                }
            }
        } catch {
            print("ERROR AL OBTENER BREACH!!!! \(error)")
        }
        return nil
    }
    func getResponseQuestion(id: Int32)->ResponseQuestion?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseQuestion.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(id)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let question = test[0] as? ResponseQuestion {
                    return question
                }
            }
        } catch {
            print("ERROR AL OBTENER BREACH!!!! \(error)")
        }
        return nil
    }
    func saveQuestions(listQuestions: [Question], idModule: Int, isEditing: Bool){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            let module = self.getModule(idModule: idModule)
            for question in listQuestions {
                let questionS = QuestionStored(context: manageContext)
                questionS.active = question.active
                questionS.id = Int32(question.id)
                questionS.topic = question.topic
                questionS.questionType = question.type
                questionS.dateSolution = question.dateSolution
                questionS.question = question.question
                questionS.order = Int32(question.order)
                questionS.topicId = Int32(question.topicId)
                questionS.questionTypeId = Int32(question.typeId)
                questionS.comment = question.comment
                questionS.commentForced = question.commentForced
                questionS.photo = question.photo
                questionS.photoForced = question.photoForced
                questionS.moduleId = Int32(question.moduleId)
                questionS.action = question.action
                questionS.legend = question.legend
                questionS.module = module
                questionS.isVisible = question.isVisibleF 
                self.saveOptions(listOptions: question.options, question: questionS, isEditing: isEditing)
            }
            do {
                try manageContext.save()
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
    func saveOptions(listOptions:[OptionQuestion], question: QuestionStored, isEditing: Bool) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            for option in listOptions {
                let optionS = OptionStored(context: manageContext)
                optionS.id = Int32(option.id)
                optionS.option = option.option
                optionS.weighing = Int32(option.weighing)
                optionS.dateSolution = option.dateSolution
                optionS.levelBreach = option.breachLevel
                optionS.subOption = option.subOption
                optionS.mail = option.mail
                optionS.breach = option.breach
                optionS.question = question
                self.saveMail(listMail: option.optionMail, option: optionS)
                self.saveBreach(listBreach: option.breaches, option: optionS)
            }
            do {
                try manageContext.save()
                for option in listOptions {
                    for suboption in option.arraySubOption {
                        self.createSuboption(suboption: suboption, optionId: option.id, isEditing: isEditing)
                    }
                }
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
    func saveMail(listMail:[OptionMail], option: OptionStored) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            for mail in listMail {
                let breachS = MailStored(context: manageContext)
                breachS.mail = mail.email
                breachS.option = option
            }
            do {
                try manageContext.save()
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }

    func saveBreach(listBreach:[Breach], option: OptionStored) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let manageContext = appDelegate.persistentContainer.viewContext
            for breach in listBreach {
                let breachS = BreachStored(context: manageContext)
                breachS.id = Int32(breach.id)
                breachS.breach = breach.description
                breachS.option = option
            }
            do {
                try manageContext.save()
            } catch {
                print("ERROR AL GUARDAR!!!! \(error)")
            }
        }
    }
}
