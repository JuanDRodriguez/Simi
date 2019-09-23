//
//  PreviewSupervision.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/31/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class PreviewSupervisionViewModel {
    static let shared = PreviewSupervisionViewModel()
    init() { }
    
    func getPreviewSupervision()->[[String: Any]] {
        let modules = Storage.shared.getModules()
        var arrayAnswerResume : [AnswerResume] = []
        var photosResume : [PhotoResume] = []
       
        for module in modules {
            let questions = Storage.shared.getQuestions(idModule: module.id)

            for question in questions {
                let comment = question.commentDescripton ?? ""
                var weighing = 1
                if let hasbreach = question.hasBreach {
                    if hasbreach {
                        weighing = -1
                    }
                }
                for option in question.options {
                    if option.isSelected {
                        print("jd**\(option.id)")
                        let responseBreach = Storage.shared.getResponseBreach(idBreach: 712)
                        print("jd**:\(responseBreach?.id), \(responseBreach?.selected)")
                        var arrayBreaches : [BreachAnswerResume] = []
                        var arraySubanswer : [SubAnswerResume] = []
                        
                        let optionStorage = Storage.shared.getOptionStored(idOption: option.id)
                        
                        if let breaches = optionStorage?.breaches?.allObjects as? [BreachStored]{
                            for breach in breaches {
                                print("jd**:\(breach.id), \(breach.breach)")
                                if let responseBreach = Storage.shared.getResponseBreach(idBreach: Int(breach.id)) {
                                     print("jd**:\(responseBreach.id), \(responseBreach.selected)")
                                    if responseBreach.selected {
                                        let breachTitle = breach.breach ?? ""
                                        let breach = BreachAnswerResume(description: breachTitle, breachLevel: responseBreach.levelBreach, dateCommitment: question.dateSolutionCommon)
                                        arrayBreaches.append(breach)
                                    }
                                }
                            }
                        }                        
                        if let suboptions = optionStorage?.suboptions?.allObjects as? [ResponseSuboption] {
                            for suboption in suboptions {
                                let sopt = SubAnswerResume(subOption: suboption.descriptionSuboption ?? "", description: suboption.answerSuboption ?? "")
                                    arraySubanswer.append(sopt)
                            }
                        }
                       // print("Question: \(question.dateSolutionCommon)")
                        for photo in question.photos {
                            let photoR = PhotoResume(questionId: question.id, photo: photo)
                            photosResume.append(photoR)
                        }
                        print("")
                        let trace = TraceResume(actionId: question.actionId ?? -1, action: question.actionDescription ?? "", dateCommitment: question.dateSolutionCommon, dateRealSolution: nil)
                        
                        let arrayTraces : [TraceResume] = [trace]
                        
                        let answerResume = AnswerResume(questionId: question.id, comment: comment, weighing: weighing, optionId: option.id, optionDescription: option.option, questionDescription: question.question, module: module.name, topic: question.topic, breaches: arrayBreaches, subAnswers: arraySubanswer, traces: arrayTraces, photos: photosResume,nivelIncumplimiento: question.hasBreach!)
                        arrayAnswerResume.append(answerResume)
                       photosResume = [PhotoResume] ()
                    }
                }
                
                
            }
        }
        let answerSupervision = EndSupervision.shared.getAnswersResume(answerResume: arrayAnswerResume)
        return answerSupervision
    }
}
