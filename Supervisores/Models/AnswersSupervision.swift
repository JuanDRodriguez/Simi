//
//  AnswersSupervision.swift
//  Supervisores
//
//  Created by Sharepoint on 12/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

struct AnswerSupervision {
    let questionId : Int
    let comment : String
    let optionSelected : Int
    let actionId: Int
    let action: String
    let breachAnswers: [BreachAnswers]
    let subAnswers: [SubAnswers]
    let traces: [Trace]
    let photos: [Photo]
    let dateCommitment: Date
    init(questionId: Int, comment: String, optionSelected: Int, breachAnswers: [BreachAnswers], subAnswers: [SubAnswers], traces:[Trace], photos:[Photo], actionId: Int, action: String, dateCommitment: Date?) {
        self.questionId = questionId
        self.comment = comment
        self.optionSelected = optionSelected
        self.breachAnswers = breachAnswers
        self.subAnswers = subAnswers
        self.traces = traces
        self.photos = photos
        self.actionId = actionId
        self.action = action
        self.dateCommitment = dateCommitment ?? Date(timeIntervalSince1970: 0)
    }
}

struct BreachAnswers {
    var breachId : Int
    var breachLevel : String
    var breachLevelId : Int
    var dateCommitment: Date?
    var dateSolutionReal: Date?
    init(breachId : Int, breachLevel : String, breachLevelId: Int, dateCommitment: Date?, dateSolutionReal: Date?){
        self.breachId = breachId
        self.breachLevel = breachLevel
        self.dateCommitment = dateCommitment
        self.dateSolutionReal = dateSolutionReal
        self.breachLevelId = breachLevelId
    }
}

struct SubAnswers {
    var subAnswerId : Int
    var description : String
    init(subAnswerId : Int, description : String) {
        self.subAnswerId = subAnswerId
        self.description = description
    }
}

struct Trace {
    var actionId : Int
    var dateCommitment: Date?
    var dateSolutionReal: Date?
    
    init(actionId : Int, dateCommitment: Date?, dateSolutionReal: Date? ) {
        self.actionId = actionId
        self.dateCommitment = dateCommitment
        self.dateSolutionReal = dateSolutionReal
    }
}

struct Photo {
    var base64Photo: String
    
    init(image : UIImage) {
        self.base64Photo = Utils.imageToBase64(image: image)
    }
}
