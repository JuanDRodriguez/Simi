//
//  QuestionsViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 15/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysQuestion: String {
    case id = "idModuleQuestion"
    case active = "activeQuestion"
    case topic = "topicQuestion"
    case type = "typeQuestion"
    case dateSolution = "dateSolutionQuestion"
    case question = "questionQuestion"
    case order = "orderQuestion"
    case topicId = "topicIdQuestion"
    case typeId = "typeIdQuestion"
    case comment = "commentQuestion"
    case commentForced = "commentForcedQuestion"
    case photo = "photoQuestion"
    case photoForced = "photoForcedQuestion"
    case listPhotos = "listPhotos"
    case moduleId = "moduleIdQuestion"
    case action = "actionQuestion"
    case legend = "legendQuestion"
    case options = "optionsQuestion"
    
    case dateCommonSolution = "commonDateSolution"
    case actionDescription = "actionDescription"
    case actionId = "actionQuestionID"
    case commentDescripton = "commentDescripton"
    case hasBreach = "questionHasBreach"
    case breachEnded = "breachEnded"
    case answered = "answeredQuestion"
}

enum KeysOptionQuestion: String {
    case id = "idOptionQuestion"
    case option = "optionOptionQuestion"
    case weighing = "weighingOptionQuestion"
    case breach = "breachOptionQuestion"
    case dateSolution = "dateSolutionOptionQuestion"
    case breachLevel = "breachLevelOptionQuestion"
    case selected = "optionSelected"
    case breaches = "breaches"
    case subOption = "subOption"
    case mail = "mailOption"
    case optionMail = "optionMail"
    case arraySubOptions = "arraySubOptions"
    case order = "order"
}

enum KeysBreachOption: String {
    case id = "idBreach"
    case description = "descriptionBreach"
    case isSelected = "isSelectBreach"
    case dateSolution = "dateSolutionBreach"
    case levelBreach = "levelBreach"
    case levelBreachId = "idLevelBreach"
}

enum KeysMailOption: String {
    case email = "emailOption"
}

enum KeysSuboptionOption: String {
    case id = "idSuboption"
    case description = "descriptionSuboption"
    case answer = "answerSuboption"
    case active = "activeSuboption"
}

@objc protocol QuestionVMProtocol {
    func questionUpdated(question: [[String: Any]])
    func finishWithError(error: Error)
    func finishLoadQuestion()
}

class QuestionViewModel {
    static let shared = QuestionViewModel()
    var listener: QuestionVMProtocol?
    init() {
    }
    var questionDictionary: [Int:[Question]] = [:]
    var questionList: [Question] = [] {
        didSet {
            var arrayQuestionMaped: [[String: Any]] = []
            let questionSorted = questionList.filter({$0.active}).sorted(by: {$0.order < $1.order})
            DispatchQueue.main.async {
                [unowned self] in
                for question in questionSorted {
                    self.addAnswersToQuestion(question: question)
                    arrayQuestionMaped.append(self.questionToDictionary(question: question))
                }
                self.listener?.questionUpdated(question: arrayQuestionMaped)
            }
        }
    }
    func addAnswersToQuestion(question: Question) {
        guard let response = Storage.shared.getResponseQuestion(id: question.id) else {
            return }
        question.commentDescripton = response.comment
        question.actionDescription = response.action
        question.actionId = Int(response.idAction)
        question.hasBreach = response.hasBreach
        question.breachEnd = response.breachFinish
        question.answered = true
    
    }
    func getQuestionBy(id: Int)->[String : Any]? {
        guard let idModule = CurrentSupervision.shared.getCurrentModule()[KeysModule.id.rawValue] as? Int else { return nil }
        guard let questionD = self.questionDictionary[idModule] else { return nil }
        let optionFilter = questionD.filter({$0.id == id})
        if optionFilter.count > 0 {
            let question = optionFilter[0]
            return questionToDictionary(question: question)
        }
        return nil
    }
    
    func addSelectedToOption(option: OptionQuestion) {
        guard let response = Storage.shared.getResponseOption(idOption: option.id) else { return }
        option.isSelected = response.selected
    }
    
    func questionToDictionary(question: Question)->[String: Any]{
        var arrayOptions :[[String: Any]] = []
        let orderOptions = question.options.sorted(by: {$0.oder < $1.oder})
        for option in orderOptions {
            self.addSelectedToOption(option: option)
            arrayOptions.append(optionToDictionary(option: option))
        }
        let questionDicto: [String : Any] = [   KeysQuestion.id.rawValue: question.id,
                                                KeysQuestion.topic.rawValue: question.topic,
                                                KeysQuestion.type.rawValue: question.type,
                                                KeysQuestion.dateSolution.rawValue: question.dateSolution,
                                                KeysQuestion.question.rawValue: question.question,
                                                KeysQuestion.order.rawValue: question.order,
                                                KeysQuestion.topicId.rawValue: question.topicId,
                                                KeysQuestion.typeId.rawValue: question.typeId,
                                                KeysQuestion.comment.rawValue: question.comment,
                                                KeysQuestion.commentForced.rawValue: question.commentForced,
                                                KeysQuestion.photo.rawValue: question.photo,
                                                KeysQuestion.photoForced.rawValue: question.photoForced,
                                                KeysQuestion.moduleId.rawValue: question.moduleId,
                                                KeysQuestion.action.rawValue: question.action,
                                                KeysQuestion.legend.rawValue: question.legend,
                                                KeysQuestion.options.rawValue: arrayOptions,
                                                KeysQuestion.answered.rawValue: question.answered,
                                                KeysQuestion.actionDescription.rawValue : question.actionDescription ?? "",
                                                KeysQuestion.actionId.rawValue : question.actionId ?? 0,
                                                KeysQuestion.commentDescripton.rawValue:                                question.commentDescripton ?? "",
                                                KeysQuestion.dateCommonSolution.rawValue: question.dateSolutionCommon ?? "",
                                                KeysQuestion.breachEnded.rawValue: question.breachEnd ?? false,
                                                KeysQuestion.hasBreach.rawValue: question.hasBreach ?? "",
                                                KeysQuestion.listPhotos.rawValue: question.photos,
                                                "isVisibleF":question.isVisibleF]
        
        return questionDicto
    }
    func optionToDictionary(option: OptionQuestion)->[String: Any] {
        var arrayBreaches :[[String: Any]] = []
        var arrayMails :[[String: Any]] = []
        var arraySuboption :[[String: Any]] = []
    
        let orderBreach = option.breaches.sorted(by: {$0.id < $1.id})
        for breach in orderBreach {
            arrayBreaches.append(breachToDictionary(breach: breach))
        }
        for mail in option.optionMail {
            arrayMails.append(optionMailToDicto(optionMail: mail))
        }
        for suboption in option.arraySubOption {
            arraySuboption.append(subOptionToDicto(subOption: suboption))
        }
        let optionQuestionDicto: [String : Any] = [   KeysOptionQuestion.id.rawValue: option.id,
                                                      KeysOptionQuestion.option.rawValue: option.option,
                                                      KeysOptionQuestion.weighing.rawValue: option.weighing,
                                                      KeysOptionQuestion.breach.rawValue: option.breach,
                                                      KeysOptionQuestion.dateSolution.rawValue: option.dateSolution,
                                                      KeysOptionQuestion.selected.rawValue : option.isSelected,
                                                      KeysOptionQuestion.breachLevel.rawValue: option.breachLevel,
                                                      KeysOptionQuestion.breaches.rawValue: arrayBreaches,
                                                      KeysOptionQuestion.subOption.rawValue: option.subOption,
                                                      KeysOptionQuestion.mail.rawValue: option.mail,
                                                      KeysOptionQuestion.optionMail.rawValue: arrayMails,
                                                      KeysOptionQuestion.order.rawValue: option.oder,
                                                      KeysOptionQuestion.arraySubOptions.rawValue: arraySuboption]
        return optionQuestionDicto
    }
    func optionMailToDicto(optionMail: OptionMail)->[String: Any] {
        let mailDicto: [String : Any] = [ KeysMailOption.email.rawValue: optionMail.email]
        return mailDicto
    }
    func subOptionToDicto(subOption: SubOption)->[String: Any] {
        let subOptionDicto: [String : Any] = [ KeysSuboptionOption.id.rawValue: subOption.id,
                                               KeysSuboptionOption.description.rawValue: subOption.description,
                                               KeysSuboptionOption.answer.rawValue: subOption.answer,
                                               KeysSuboptionOption.active.rawValue: subOption.active]
        return subOptionDicto
    }
    func breachToDictionary(breach: Breach)->[String: Any] {
        let breachDicto: [String : Any] = [ KeysBreachOption.id.rawValue: breach.id,
                                            KeysBreachOption.dateSolution.rawValue : breach.breachDate ?? "",
                                            KeysBreachOption.levelBreach.rawValue: breach.breachLevel,
                                            KeysBreachOption.levelBreachId.rawValue : breach.breachLevelId,
                                            KeysBreachOption.isSelected.rawValue: breach.breachSelected,
                                            KeysBreachOption.description.rawValue: breach.description]
        return breachDicto
    }
    func setListener(listener: QuestionVMProtocol?) {
        self.listener = listener
    }
    func getQuestion(moduleId : Int, ovirrideCurrent: Bool, isEditing: Bool, type: String) -> Bool {
        if !ovirrideCurrent {
            if let questionDictionary = self.questionDictionary[moduleId] {
                self.questionList = questionDictionary
                return true
            }
            let questionStored = Storage.shared.getQuestions(idModule: moduleId)
            if questionStored.count > 0 {
                self.questionList = questionStored
                self.questionDictionary[moduleId] = questionStored
                return true
            }
        }
        NetworkingServices.shared.getQuestions(idModule:moduleId) {
            [unowned self] in
            if let error = $1 {
                self.reportErrorToListeners(error: error)
                
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.reportErrorToListeners(error: error)
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                self.reportErrorToListeners(error: parsingError)
                print("Error", parsingError.localizedDescription)
            }
            do {
                let decoder = JSONDecoder()
                var questions = try decoder.decode([Question].self, from: data)
                if questions.count > 0 {
                   if type == "Franquicia"{
                       let  questionsF = questions.filter({
                            $0.isVisibleF == true
                        })
                        questions = questionsF
                    }
                    self.questionDictionary[moduleId] = questions
                }
                self.questionList = questions
                Storage.shared.saveQuestions(listQuestions: self.questionList, idModule: moduleId, isEditing: isEditing)
                self.questionList.removeAll()
                
                self.listener?.finishLoadQuestion()
            } catch let error {
                
                self.reportErrorToListeners(error: error)
            }
        }
        return false
    }
    
    func sendMailSuboption(arraySuboptions : [[String: Any]], optionId: Int) {
        guard let unitId = CurrentSupervision.shared.getCurrentUnit()[KeysQr.unitId.rawValue] as? Int else {return}
        let arraySubOpt:[[String: String]] = arraySuboptions.map({
            let dicto = [
                "SubOpcion": $0[KeysSuboptionOption.description.rawValue] as? String ?? "",
                "Descripcion": $0[KeysSuboptionOption.answer.rawValue] as? String ?? "",
            ]
            return dicto
        })
        NetworkingServices.shared.sendMailSuboption(arraySuboptions: arraySubOpt, unitId: unitId, optionId: optionId) {
            [unowned self] in
            if let error = $1 {
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.reportErrorToListeners(error: error)
                return
            }
           // print("Data ==>> \(data)")
        }
    }
    
    func reportErrorToListeners(error: Error) {
        self.listener?.finishWithError(error: error)
    }
    
    func resetQuestions() {
        self.questionDictionary = [:]
        self.questionList = []
    }
}
