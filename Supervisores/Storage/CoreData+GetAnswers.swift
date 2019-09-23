//
//  CoreData+GetAnswers.swift
//  Supervisores
//
//  Created by Sharepoint on 12/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension CoreDataStorage {
    func getAllAnswers()->[AnswerSupervision] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseQuestion.rawValue)
        do {
            let responseQuestions = try manageContext.fetch(moduleRequest) as! [ResponseQuestion]
            var arrayAnswers:[AnswerSupervision] = []
            
            for question in responseQuestions {
                let options = question.options?.allObjects as! [ResponseOption]
                let photosStored = question.photos?.allObjects as! [ResponsePhoto]
                let photos = self.getPhotos(photosStored: photosStored)
                let subAnwers = self.getSuboptions(options: options)
                let optionsSelected = self.getOptionSelected(options: options)
                for option in optionsSelected {
                    var answer : AnswerSupervision
                    let breachAnswers = self.getBeachesOption(option: option, question: question)
                    answer = AnswerSupervision(questionId: Int(question.id), comment: question.comment ?? "", optionSelected: Int(option.id), breachAnswers: breachAnswers, subAnswers: subAnwers, traces:  [], photos: photos, actionId: Int(question.idAction), action: question.action ?? "", dateCommitment: question.dateSolutionCommon )
                    
                    arrayAnswers.append(answer)
                }
            }
            return arrayAnswers
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return []
    }
    func getOptionSelected(options: [ResponseOption])->[ResponseOption]{
        var optionsSelected : [ResponseOption] = []
        for option in options {
            if option.selected {
                optionsSelected.append(option)
            }
        }
        return optionsSelected
    }
    func getSuboptions(options: [ResponseOption])->[SubAnswers] {
        var suboptionsArray : [SubAnswers] = []
        for option in options{
            let optionStored = self.getOptionStored(idOption: Int(option.id))
            guard let suboptions = optionStored?.suboptions?.allObjects as? [ResponseSuboption] else {continue}
            for suboptionResponse in suboptions {
                if suboptionResponse.active && suboptionResponse.answerSuboption != "" {
                    let subOpt = SubAnswers(subAnswerId: Int(suboptionResponse.suboptionId), description: suboptionResponse.answerSuboption ?? "")
                    suboptionsArray.append(subOpt)
                }
            }
        }
        return suboptionsArray
    }
    func getBeachesOption(option: ResponseOption?, question: ResponseQuestion)->[BreachAnswers]{
        guard let optionSelected = option else { return []}
        let breaches = optionSelected.breaches?.allObjects as! [ResponseBreach]
        let breachAnsw: [BreachAnswers] = breaches.filter({$0.selected}).map({
            var dateCommitment: Date? = $0.dateSolution
            if let dateCommon = question.dateSolutionCommon {
                dateCommitment = dateCommon
            }
            let breach = BreachAnswers(breachId: Int($0.id), breachLevel: $0.levelBreach ?? "", breachLevelId: Int($0.levelBreachId), dateCommitment: dateCommitment, dateSolutionReal: nil)
            return breach
        })
        return breachAnsw
    }
    func getPhotos(photosStored:[ResponsePhoto])->[Photo]{
        
        var photos: [Photo] = []
        DispatchQueue.global().async {
            [weak self] in
           
        for pho in photosStored {
            if let data = pho.photo {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: data)) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            photos.append(Photo
                            .init(image: image))
                        }
                    }
                }
            }
            }
            
        }
        return photos
    }

    func getResponseBreach(idBreach: Int)->ResponseBreach? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let manageContext = appDelegate.persistentContainer.viewContext
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.responseBreach.rawValue)
        moduleRequest.predicate = NSPredicate(format: "id == \(idBreach)")
        do {
            let test = try manageContext.fetch(moduleRequest)
            if test.count > 0 {
                if let option = test[0] as? ResponseBreach {
                    return option
                }
            }
        } catch {
            print("ERROR AL OBTENER MOULO!!!! \(error)")
        }
        return nil
    }
}
