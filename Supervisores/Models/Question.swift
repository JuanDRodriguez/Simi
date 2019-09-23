//
//  Question.swift
//  Supervisores
//
//  Created by Sharepoint on 15/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class Question : Decodable {
    var id : Int
    var active : Bool
    var topic : String
    var type : String
    var dateSolution : Bool
    var question: String
    var order: Int
    var topicId: Int
    var typeId: Int
    var comment: Bool
    var commentForced: Bool
    var photo: Bool
    var photoForced: Bool
    var moduleId: Int
    var action: Bool
    var legend: String
    var isVisibleF: Bool
    var actionDescription: String?
    var actionId: Int?
    var commentDescripton : String?
    var dateSolutionCommon: Date?
    var hasBreach: Bool?
    var breachEnd: Bool?
    var answered: Bool = false
    var options: [OptionQuestion]
    var photos:[UIImage] = []
    private enum CodingKeys: String, CodingKey {
        case id = "PreguntaId"
        case active = "Activo"
        case topic = "Tema"
        case type = "TipoPregunta"
        case dateSolution = "FechaSolucion"
        case question = "Pregunta"
        case order = "Orden"
        case topicId = "TemaId"
        case typeId = "TipoPreguntaId"
        case comment = "Comentario"
        case commentForced = "ComentarioObligatorio"
        case photo = "EvidenciaFotografica"
        case photoForced = "EvidenciaFObligatoria"
        case moduleId = "ModuloId"
        case action = "Accion"
        case legend = "Leyenda"
        case options = "Opciones"
        case isVisibleF = "VisibleContacto"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        self.topic = try container.decodeIfPresent(String.self, forKey: .topic) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.dateSolution = try container.decodeIfPresent(Bool.self, forKey: .dateSolution) ?? false
        self.question = try container.decodeIfPresent(String.self, forKey: .question) ?? ""
        self.order = try container.decodeIfPresent(Int.self, forKey: .order) ?? -1
        self.topicId = try container.decodeIfPresent(Int.self, forKey: .topicId) ?? -1
        self.typeId = try container.decodeIfPresent(Int.self, forKey: .typeId) ?? -1
        self.comment = try container.decodeIfPresent(Bool.self, forKey: .comment) ?? false
        self.commentForced = try container.decodeIfPresent(Bool.self, forKey: .commentForced) ?? false
        self.photo = try container.decodeIfPresent(Bool.self, forKey: .photo) ?? false
        self.photoForced = try container.decodeIfPresent(Bool.self, forKey: .photoForced) ?? false
        self.moduleId = try container.decodeIfPresent(Int.self, forKey: .moduleId) ?? -1
        self.action = try container.decodeIfPresent(Bool.self, forKey: .action) ?? false
        self.legend = try container.decodeIfPresent(String.self, forKey: .legend) ?? ""
        self.options = try container.decode([OptionQuestion].self, forKey: .options)
        self.isVisibleF  = try container.decodeIfPresent(Bool.self, forKey: .isVisibleF) ?? true
    }
    
    init(questionS: QuestionStored, listOptions: [OptionQuestion], questionAnswer: ResponseQuestion?, photos: [UIImage]) {
        self.id = Int(questionS.id)
        self.active = questionS.active
        self.topic = questionS.topic ?? ""
        self.type = questionS.questionType ?? ""
        self.dateSolution = questionS.dateSolution
        self.question = questionS.question ?? ""
        self.order = Int(questionS.order)
        self.topicId = Int(questionS.topicId)
        self.typeId = Int(questionS.questionTypeId)
        self.comment = questionS.comment
        self.commentForced = questionS.commentForced
        self.photo = questionS.photo
        self.photoForced = questionS.photoForced
        self.moduleId = Int(questionS.moduleId)
        self.action = questionS.action
        self.legend = questionS.legend ?? ""
        self.isVisibleF = questionS.isVisible
        if let actionId = questionAnswer?.idAction {
            self.actionId = Int(actionId)
        }
        self.photos = photos
        if let questAnsw = questionAnswer {
            self.dateSolutionCommon = questAnsw.dateSolutionCommon
            self.actionDescription = questAnsw.action
            self.commentDescripton = questAnsw.comment
            self.hasBreach = questAnsw.hasBreach
            self.breachEnd = questAnsw.breachFinish
        } else {
            self.actionDescription = ""
            self.commentDescripton = ""
            self.hasBreach = false
        }
        self.options = listOptions
    }
    
    init (idQuestion: Int, actionDescription: String, actionId: Int, coment: String, hasBreach: Bool, dateCommonSolution: Date?, moduleId: Int, isVisible: Bool) {
        self.id = idQuestion //responseQuestion.id = Int32(question.id)
        self.actionDescription = actionDescription //responseQuestion.action = question.actionDescription
        self.actionId = actionId
//        if let actionId = question.actionId {
//            responseQuestion.idAction = Int16(actionId)
//        }
        if coment != "" {
            self.comment =  true
            self.commentDescripton = coment //responseQuestion.comment = question.commentDescripton
        } else {
            self.comment =  false
        }
        self.hasBreach = hasBreach //responseQuestion.hasBreach = question.hasBreach ?? false
        if hasBreach {
            self.breachEnd = true //responseQuestion.breachFinish = question.breachEnd ?? false
        }
        if let dateCommonSol = dateCommonSolution {
            self.dateSolution = true
            self.dateSolutionCommon = dateCommonSol //responseQuestion.dateSolutionCommon = question.dateSolutionCommon
        } else {
            self.dateSolution = false
        }
        self.moduleId = moduleId //responseQuestion.module = self.getResponseModule(idModule: Int32(question.moduleId))
        
        self.active = true
        self.topic = ""
        self.type = ""
        self.question = ""
        self.order = -1
        self.topicId = -1
        self.typeId = -1
        self.commentForced = false
        self.photo = false
        self.photoForced = false
        self.action =  false
        self.legend = ""
        self.options = []
        self.isVisibleF = isVisible
    }
}

class OptionMail: Decodable {
    var email: String
    private enum CodingKeys: String, CodingKey {
        case email = "Correo"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
    init(email: String) {
        self.email = email
    }
}

class OptionQuestion : Decodable {
    var id : Int
    var option : String
    var weighing : Int
    var breach : Bool
    var dateSolution : Bool
    var breachLevel: Bool
    var subOption : Bool
    var mail : Bool
    var optionMail : [OptionMail]
    var breaches : [Breach]
    var isSelected : Bool
    var arraySubOption: [SubOption]
    var oder: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "OpcionId"
        case option = "Opcion"
        case weighing = "Ponderacion"
        case breach = "Incumplimiento"
        case dateSolution = "FechaSolucion"
        case breachLevel = "NivelIncumplimiento"
        case breaches = "Incumplimientos"
        case subOption = "Subopcion"
        case mail = "Correo"
        case optionMail = "CorreoOpcion"
        case arraySubOption = "SubopcionOpcion"
        case order = "Orden"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.option = try container.decodeIfPresent(String.self, forKey: .option) ?? ""
        self.weighing = try container.decodeIfPresent(Int.self, forKey: .weighing) ?? -1
        self.oder = try container.decodeIfPresent(Int.self, forKey: .order) ?? -1
        self.breach = try container.decodeIfPresent(Bool.self, forKey: .breach) ?? false
        self.dateSolution = try container.decodeIfPresent(Bool.self, forKey: .dateSolution) ?? false
        self.breachLevel = try container.decodeIfPresent(Bool.self, forKey: .breachLevel) ?? false
        self.subOption = try container.decodeIfPresent(Bool.self, forKey: .subOption) ?? false
        self.mail = try container.decodeIfPresent(Bool.self, forKey: .mail) ?? false
        self.optionMail = try container.decodeIfPresent([OptionMail].self, forKey: .optionMail) ?? []
        self.breaches = try container.decode([Breach].self, forKey: .breaches)
        self.arraySubOption = try container.decode([SubOption].self, forKey: .arraySubOption)
        self.isSelected = false
    }
    
    init(optionS: OptionStored, listBreach: [Breach], selected : Bool, mails:[OptionMail], suboptions: [SubOption]) {
        self.id = Int(optionS.id)
        self.option = optionS.option ?? ""
        self.weighing = Int(optionS.weighing)
        self.breach = optionS.breach
        self.dateSolution = optionS.dateSolution
        self.breachLevel = optionS.levelBreach
        self.subOption = optionS.subOption
        self.mail = optionS.mail
        self.breaches = listBreach
        self.isSelected = selected
        self.arraySubOption = suboptions
        self.optionMail = mails
        self.oder = Int(optionS.id)
    }
    
    
    init(optionId: Int) {
        self.id = optionId
        self.isSelected = true

        self.option = ""
        self.weighing = 0
        self.breach = false
        self.dateSolution = false
        self.breachLevel = false
        self.subOption = false
        self.mail = false
        self.breaches = []
        self.arraySubOption = []
        self.optionMail = []
        self.oder = 0
    }
}

class SubOption: Decodable {
    var id : Int
    var idSuboption : Int
    var description : String
    var active: Bool
    var answer: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "SubOpcionId"
        case description = "Nombre"
        case active = "Activo"
        case idSuboption = "SubopcionOpcionId"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? false
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.answer = ""
        self.idSuboption = try container.decodeIfPresent(Int.self, forKey: .idSuboption) ?? -1
    }
    init(optionS: ResponseSuboption) {
        self.id = Int(optionS.id)
        self.description = optionS.descriptionSuboption ?? ""
        self.answer = optionS.answerSuboption ?? ""
        self.active = optionS.active
        self.idSuboption = Int(optionS.suboptionId)
    }
}

class Breach: Decodable {
    var id : Int
    var description : String
    var breachLevel : String
    var breachLevelId : Int
    var breachSelected : Bool
    var breachDate : Date?
    
    private enum CodingKeys: String, CodingKey {
        case id = "IncumplimientoId"
        case description = "Descripcion"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.breachLevel = ""
        self.breachSelected = false
        self.breachDate = nil
        self.breachLevelId = -1
    }
    init(breachS: BreachStored, breachLevel : String = "", breachLevelId : Int, breachLevelSelected: Bool = false, breachDate: Date? = nil){
        self.id = Int(breachS.id)
        self.description = breachS.breach ?? ""
        self.breachLevel = breachLevel
        self.breachSelected = breachLevelSelected
        self.breachDate = breachDate
        self.breachLevelId = breachLevelId
    }
}
