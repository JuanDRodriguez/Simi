//
//  QuestionViewModel+Updates.swift
//  Supervisores
//
//  Created by Sharepoint on 06/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension QuestionViewModel {
    func setQuestions(module: Int, listQuestions : [Question]){
        questionDictionary[module] = listQuestions
    }
    func updateBreach(breach: [String: Any], idOption: Int, idQuestion: Int){
       
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return }
        guard let questionD = self.questionDictionary[idModule] else { return }
        let listQuestions : [Question] = questionD.map({
            if $0.id == idQuestion {
                $0.options = self.updateBreach(breach: breach, idOption: idOption, options: $0.options)
            }
            return $0
        })
        self.questionDictionary[idModule] = listQuestions
    }
    
    func updateBreach(breach: [String: Any], idOption: Int, options:[OptionQuestion])->[OptionQuestion]{
        let optionsReturn : [OptionQuestion] = options.map({
            if $0.id == idOption {
                $0.breaches = self.updateBreach(breaches: $0.breaches, breach: breach)
            }
            return $0
        })
        return optionsReturn
    }
    func updateBreach(breaches:[Breach], breach:[String: Any])->[Breach]{
        let breachesReturn : [Breach] = breaches.map({
            if let idBreach = breach[KeysBreachOption.id.rawValue] as? Int {
                if $0.id == idBreach {
                    $0.breachSelected = breach[KeysBreachOption.isSelected.rawValue] as? Bool ?? false
                    $0.breachDate = breach[KeysBreachOption.dateSolution.rawValue] as? Date ?? Date(timeIntervalSince1970: 0)
                    $0.breachLevel = breach[KeysBreachOption.levelBreach.rawValue] as? String ?? ""
                    $0.breachLevelId = breach[KeysBreachOption.levelBreachId.rawValue] as? Int ?? -1
                }
            }
            return $0
        })
        return breachesReturn
    }
    func updateQuestionResponse(idQuestion: Int, dateSolutionCommon : Date? = nil, actionId: Int = -1, actionDescription: String = "", comment : String = "", hasBreach : Bool = false, completeBreach : Bool = false) {
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return }
        guard let questionD = self.questionDictionary[idModule] else { return }
        let listQuestions : [Question] = questionD.map({
            if $0.id == idQuestion {
                if actionDescription != "" {
                    $0.actionDescription = actionDescription
                }
                if actionId != -1 {
                    $0.actionId = actionId
                }
                $0.commentDescripton = comment
                $0.hasBreach = hasBreach
                if dateSolutionCommon != nil {
                    $0.dateSolutionCommon = dateSolutionCommon
                }
                $0.breachEnd = completeBreach
            }
            return $0
        })
        self.questionDictionary[idModule] = listQuestions
    }
    func optionSelected(idQuestion: Int, idOption: Int, selected: Bool) {
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return }
        guard let questionD = self.questionDictionary[idModule] else { return }
        let listQuestions : [Question] = questionD.map({
            if $0.id == idQuestion{
                $0.options = $0.options.map({option in
                    if option.id == idOption{
                        option.isSelected = selected
                    }
                    return option
                })
            }
            return $0
        })
        self.questionDictionary[idModule] = listQuestions
    }
    func saveQuestion(idQuestion: Int, isEditing: Bool) {
        print("GUARDANDO PREGUNTA ===>> \(idQuestion)")
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return }
        guard let questionD = self.questionDictionary[idModule] else { return }
        let qFilter = questionD.filter({$0.id == idQuestion})
        if qFilter.count <= 0 {return}
        var question: Question? = qFilter[0]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if question!.hasBreach ?? false {
                for (i, photo) in (question!.photos).enumerated() {
                    NetworkingServices.shared.uploadImage(images: [photo], clave: SupervisionViewController.unitId, date: Utils.stringFromDateNowName(), tipo: "Supervicion" ){
                         [unowned self] in
                        if let error = $1 {
                            print("ERROR ==> \(error)")
                            
                            return
                        }
                        if let dataPhoto = $0 {
                            do {
                                let decoder = JSONDecoder()
                                var photoUpload = try decoder.decode(PhotoUpload.self, from: dataPhoto) ?? nil
                                
                                for url in photoUpload!.urlImage {
                                    Storage.shared.savePhotoString(photo: url, position:i, idQuestion: idQuestion, isEditing: isEditing)
                                }
                                photoUpload = nil
                                question!.photos = []
                                
                                NetworkingServices.shared =  NetworkingServices()
                                Storage.shared = Storage()
                            } catch let error {
                                print("ERROR == PHOTOS>> \(error)")
                            }
                        } else {
                            
                            return
                        }
                        
                    }
                    
                }
                
                
                
            } else {
                for (i, _) in (question!.photos).enumerated() {
                    Storage.shared.deletePhoto(position: i, questionId: idQuestion)
                }
            }
            Storage.shared.updateResponseQuestion(question: question!, isEditing: isEditing)
            for option in question!.options {
                print("GUARDANDO OPCION PREGUNTA ===>> \(option.option) \(isEditing)")
                print("jd**\(option.id)")
                Storage.shared.updateOptionResponse( option: option, idQuestion: idQuestion, isEditing: isEditing)
                for breach in option.breaches {
                    if question!.hasBreach ?? false {
                        Storage.shared.updateResponseBreach(breach: breach, optionId: option.id, isEditing: isEditing)
                    }
                    else {
                        breach.breachSelected = false
                        Storage.shared.updateResponseBreach(breach: breach, optionId: option.id, isEditing: isEditing)
                    }
                }
                for suboption in option.arraySubOption{
                    if question!.hasBreach ?? false {
                        Storage.shared.updateSuboption(suboption: suboption, optionId: option.id, isEditing: isEditing)
                        
                    } else {
                        suboption.answer = ""
                        Storage.shared.updateSuboption(suboption: suboption, optionId: option.id, isEditing: isEditing)
                    }
                }
            }
            
            
        }
        
    }
    func saveDictoToAnswer(dictoAnswer: [String: Any], isEditing: Bool) {
        guard let idQuestion = dictoAnswer[KeysAnswerResume.questionId.rawValue] as? Int else { return }
        let actionDescription = "PROMESA"//dictoAnswer[KeysAnswerResume.optionDescription.rawValue] as? String else { return }
        guard let optionId = dictoAnswer[KeysAnswerResume.optionSelectedId.rawValue] as? Int else { return }
        let actionId = 0//dictoAnswer[KeysAnswerResume..rawValue] as? Int else { return }
        guard let comment = dictoAnswer[KeysAnswerResume.comment.rawValue] as? String else { return }
        guard let weighing = dictoAnswer[KeysAnswerResume.weighing.rawValue] as? Int else { return }
        guard let moduleId = dictoAnswer[KeysAnswerResume.moduleId.rawValue] as? Int else { return }
        
        let answerQuestion = Question(idQuestion: idQuestion, actionDescription: actionDescription, actionId: actionId, coment: comment, hasBreach: weighing < 0, dateCommonSolution: nil, moduleId: moduleId,isVisible: false)
        Storage.shared.updateResponseQuestion(question: answerQuestion, isEditing: isEditing)
        let option = OptionQuestion(optionId: optionId)
        Storage.shared.updateOptionResponse(option: option, idQuestion: idQuestion, isEditing: isEditing)
    }
    func addImage(idQuestion: Int, img: UIImage, position: Int) {
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return }
        guard var questionD = self.questionDictionary[idModule] else { return }
        questionD = questionD.map({
            if $0.id == idQuestion {
                $0.photos.append(img)
            }
            return $0
        })
        self.questionDictionary[idModule] = questionD
    }
    func updateOptionSuboption(idQuestion: Int, idOption: Int, idSuboption: Int, answer: String){
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return }
        guard var questionD = self.questionDictionary[idModule] else { return }
        questionD = questionD.map({
            if $0.id == idQuestion {
                $0.options = self.updateSuboption(options: $0.options, idOption: idOption, idSuboption: idSuboption, answer: answer)
            }
            return $0
        })
        self.questionDictionary[idModule] = questionD
    }
    func updateSuboption(options: [OptionQuestion], idOption: Int, idSuboption: Int, answer: String)->[OptionQuestion]{
        let optionsUpdated:[OptionQuestion] = options.map({
            if $0.id == idOption {
                $0.arraySubOption = self.updateSuboption(suboptions: $0.arraySubOption, idSuboption: idSuboption, answer: answer)
            }
            return $0
        })
        return optionsUpdated
    }
    func updateSuboption(suboptions: [SubOption], idSuboption: Int, answer: String)->[SubOption]{
        let subUpdated:[SubOption] = suboptions.map({
            if $0.id == idSuboption {
                $0.answer = answer
            }
            return $0
        })
        return subUpdated
    }
    func getSuboptions(questionId: Int, optionId: Int)->[[String: Any]]{
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return [] }
        guard let questionD = self.questionDictionary[idModule] else { return [] }
        for question in questionD {
            if question.id == questionId {
                for option in question.options {
                    if option.id == optionId {
                        let arraySuboptions:[[String: Any]] = option.arraySubOption.map({
                            let dicto = self.subOptionToDicto(subOption: $0)
                            return dicto
                        })
                        return arraySuboptions
                    }
                }
            }
        }
        return []
    }
}
