//
//  ResumeSupervision.swift
//  Supervisores
//
//  Created by Sharepoint on 15/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class ResumeSupervision: Decodable {
    var supervisionId : Int
    var supervisorKey : String
    var dateInit : Date?
    var dateEnd : Date?
    var userId : Int
    var userAccountDomain : String
    var lat : Double
    var lng : Double
    var rate : Int
    var description : String
    var visit : Bool
    var nocturne : Bool
    var complete : Bool
    var unit : UnitResume?
    var answers : [AnswerResume]
    
    private enum CodingKeys: String, CodingKey {
        case supervisionId = "SupervisionId"
        case supervisorKey = "ClaveSupervisor"
        case dateInit = "FechaInicio"
        case dateEnd = "FechaFin"
        case userId = "UsuarioId"
        case userAccountDomain = "Usuario"
        case lat = "Latitud"
        case lng = "Longitud"
        case rate = "Estrellas"
        case description = "Descripcion"
        case visit = "Visita"
        case nocturne = "Nocturna"
        case complete = "Completa"
        case unit = "UnidadNegocio"
        case answers = "Respuestas"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.supervisionId = try container.decodeIfPresent(Int.self, forKey: .supervisionId) ?? 0
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateInit) {
            self.dateInit = Utils.dateFromService(stringDate: stringDate)
        }
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateEnd) {
            self.dateEnd = Utils.dateFromService(stringDate: stringDate)
        }
        self.userAccountDomain = try container.decodeIfPresent(String.self, forKey: .userAccountDomain) ?? ""
        self.supervisorKey = try container.decodeIfPresent(String.self, forKey: .supervisorKey) ?? ""
        self.userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        self.lng = try container.decodeIfPresent(Double.self, forKey: .lng) ?? 0.0
        self.rate = try container.decodeIfPresent(Int.self, forKey: .rate) ?? 0
        self.unit = try container.decodeIfPresent(UnitResume.self, forKey: .unit)
        self.answers = try container.decode([AnswerResume].self, forKey: .answers)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""

        self.visit = try container.decodeIfPresent(Bool.self, forKey: .visit) ?? false
        self.nocturne = try container.decodeIfPresent(Bool.self, forKey: .nocturne) ?? false
        self.complete = try container.decodeIfPresent(Bool.self, forKey: .complete) ?? false
    }
}

class UnitResume: Decodable {
    var unitId : Int
    var unitKey : String
    var unitName : String
    var unitLat : Double
    var unitLng : Double
    var unitType : Int
    var unitContact : String
    var unitBussinesName : String
    var unitStreet : String
    var unitNumberExt : String
    var unitColony : String
    var unitCity : String
    var unitCP : String
    var unitState: String
    
    private enum CodingKeys: String, CodingKey {
        case unitId = "UnidadNegocioId"
        case unitKey = "Clave"
        case name = "Nombre"
        case lat = "Latitud"
        case lng = "Longitud"
        case unitType = "TipoUnidadId"
        case contact = "Contacto"
        case bussinesName = "RazonSocial"
        case street = "Calle"
        case numberExt = "NumeroExterior"
        case colony = "Colonia"
        case city = "Ciudad"
        case cp = "CodigoPostal"
        case state = "Estado"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.unitId = try container.decodeIfPresent(Int.self, forKey: .unitId) ?? 0
        self.unitKey = try container.decodeIfPresent(String.self, forKey: .unitKey) ?? ""
        self.unitName = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.unitLat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        self.unitLng = try container.decodeIfPresent(Double.self, forKey: .lng) ?? 0
        self.unitType = try container.decodeIfPresent(Int.self, forKey: .unitType) ?? 0
        self.unitContact = try container.decodeIfPresent(String.self, forKey: .contact) ?? ""
        self.unitBussinesName = try container.decodeIfPresent(String.self, forKey: .bussinesName) ?? ""
        self.unitStreet = try container.decodeIfPresent(String.self, forKey: .street) ?? ""
        self.unitNumberExt = try container.decodeIfPresent(String.self, forKey: .numberExt) ?? ""
        self.unitColony = try container.decodeIfPresent(String.self, forKey: .colony) ?? ""
        self.unitCity = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.unitCP = try container.decodeIfPresent(String.self, forKey: .cp) ?? ""
        self.unitState = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
    }
}

class PhotoResume: Decodable {
    var id: Int
    var questionId : Int
    var photo : UIImage?
    var photoUrl : String
    private enum CodingKeys: String, CodingKey {
        case id = "FotografiaId"
        case questionId = "PreguntaId"
        case photo = "Url"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.questionId =  try container.decodeIfPresent(Int.self, forKey: .questionId) ?? 0
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photo) ?? ""
//        if let stringImage = try container.decodeIfPresent(String.self, forKey: .photo) {
//             self.photo = UIImage(
//                 Utils.base64ToImage(base64String: stringImage)
//            print("BUSCANDO IMAGEN")
//            
//            if let url = URL(string: stringImage) {
//                do {
//                    let data = try? Data(contentsOf: url)
//                    DispatchQueue.main.async {
//                        if let dataImg = data {
//                            if let img = UIImage(data: dataImg) {
//                                self.photo = img
//                            } else {
//                                self.photo = UIImage(named: "file-not-found")
//                            }
//                        } else {
//                            self.photo = UIImage(named: "file-not-found")
//                        }
//                    }
//                }
//            } else  {
//                self.photo = UIImage(named: "file-not-found")
//            }
//        }
    }
    init(questionId:Int, photo: UIImage) {
        self.id = 0
        self.questionId = questionId
        self.photo = photo
        self.photoUrl = ""
    }
}

class AnswerResume: Decodable {
    var answerId : Int
    var supervisionId : Int
    var optionId : Int
    var weighing : Int
    var comment : String
    var optionDescription : String
    var questionDescription : String
    var questionId : Int
    var module : String
    var topic : String
    var moduleId : Int
    var nivelIncumplimiento: Bool
    var breaches : [BreachAnswerResume]
    var subAnswers : [SubAnswerResume]
    var traces : [TraceResume]
    var photos : [PhotoResume]

    private enum CodingKeys: String, CodingKey {
        case answerId = "RespuestaId"
        case comment = "Comentario"
        case supervisionId = "SupervisionId"
        case weighing = "PonderacionOpcion"
        case optionId = "OpcionId"
        case optionDescription = "Opcion"
        case questionDescription = "Pregunta"
        case module = "Modulo"
        case topic = "Tema"
        case breaches = "IncumplimientoRespuesta"
        case subAnswers = "SubRespuesta"
        case traces = "Seguimiento"
        case questionId = "PreguntaId"
        case photos = "Fotografias"
        case moduleId = "ModuloId"
        case nivelIncumplimiento = "NivelIncumplimiento"
        
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.answerId = try container.decodeIfPresent(Int.self, forKey: .answerId) ?? 0
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment) ?? ""
        self.supervisionId = try container.decodeIfPresent(Int.self, forKey: .supervisionId) ?? 0
        self.weighing = try container.decodeIfPresent(Int.self, forKey: .weighing) ?? 0
        self.questionId = try container.decodeIfPresent(Int.self, forKey: .questionId) ?? 0
        self.optionId = try container.decodeIfPresent(Int.self, forKey: .optionId) ?? 0
        self.optionDescription = try container.decodeIfPresent(String.self, forKey: .optionDescription) ?? ""
        self.questionDescription = try container.decodeIfPresent(String.self, forKey: .questionDescription) ?? ""
        self.module = try container.decodeIfPresent(String.self, forKey: .module) ?? ""
        self.moduleId = try container.decodeIfPresent(Int.self, forKey: .moduleId) ?? -1
        self.topic = try container.decodeIfPresent(String.self, forKey: .topic) ?? ""
        self.breaches = try container.decode([BreachAnswerResume].self, forKey: .breaches)
        self.subAnswers = try container.decode([SubAnswerResume].self, forKey: .subAnswers)
        self.traces = try container.decode([TraceResume].self, forKey: .traces)
        self.photos  = try container.decode([PhotoResume].self, forKey: .photos)
        self.nivelIncumplimiento = try container.decodeIfPresent(Bool.self, forKey: .nivelIncumplimiento) ?? false
    }
    init(questionId: Int, comment: String, weighing: Int, optionId: Int, optionDescription: String, questionDescription: String, module: String, topic: String, breaches: [BreachAnswerResume], subAnswers: [SubAnswerResume], traces: [TraceResume], photos: [PhotoResume],nivelIncumplimiento: Bool) {
        self.questionId = questionId
        self.answerId = 0
        self.comment = comment
        self.supervisionId = -1
        self.weighing = weighing
        self.optionId = optionId
        self.optionDescription = optionDescription
        self.questionDescription = questionDescription
        self.module = module
        self.topic = topic
        self.breaches = breaches
        self.subAnswers = subAnswers
        self.traces = traces
        self.photos = photos
        self.moduleId = -1
        self.nivelIncumplimiento = nivelIncumplimiento
    }
}

class BreachAnswerResume: Decodable {
    var breachId : Int
    var description : String
    var answerId : Int
    var breachLevel : String
    var dateCommitment : Date?
    var dateRealSolution : Date?
    var status: String?
    
    private enum CodingKeys: String, CodingKey {
        case breachId = "IncumplimientoId"
        case description = "Descripcion"
        case answerId = "RespuestaId"
        case breachLevel = "NivelIncumplimiento"
        case dateCommitment = "FechaCompromiso"
        case dateRealSolution = "FechaRealSolucion"
        case status = "Estatus"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.breachId = try container.decodeIfPresent(Int.self, forKey: .breachId) ?? 0
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.answerId = try container.decodeIfPresent(Int.self, forKey: .answerId) ?? 0
        self.breachLevel = try container.decodeIfPresent(String.self, forKey: .breachLevel) ?? ""
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateCommitment) {
            self.dateCommitment = Utils.dateFromService(stringDate: stringDate)
        }
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateRealSolution) {
            self.dateRealSolution = Utils.dateFromService(stringDate: stringDate)
        }
    }
    
    init (description: String, breachLevel: String?, dateCommitment: Date?){
        self.breachId = -1
        self.answerId = -1
        
        self.description = description
        self.breachLevel = breachLevel ?? ""
        self.dateCommitment = dateCommitment
    }
}

class SubAnswerResume: Decodable {
    var subOption : String
    var description : String
    
    private enum CodingKeys: String, CodingKey {
        case subOption = "SubOpcion"
        case description = "Descripcion"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subOption = try container.decodeIfPresent(String.self, forKey: .subOption) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }
    
    init (subOption: String, description: String) {
        self.subOption = subOption
        self.description = description
    }
}

class TraceResume: Decodable {
    var traceId : Int
    var answerId : Int
    var actionId : Int
    var action : String
    var dateCommitment : Date?
    var dateRealSolution : Date?

    private enum CodingKeys: String, CodingKey {
        case traceId = "SeguimientoId"
        case answerId = "RespuestaId"
        case action = "Accion"
        case actionId = "AccionId"
        case dateCommitment = "FechaComprimiso"
        case dateRealSolution = "FechaRealSolucion"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.traceId = try container.decodeIfPresent(Int.self, forKey: .traceId) ?? 0
        self.answerId = try container.decodeIfPresent(Int.self, forKey: .answerId) ?? 0
        self.action = try container.decodeIfPresent(String.self, forKey: .action) ?? ""
        self.actionId = try container.decodeIfPresent(Int.self, forKey: .actionId) ?? 0
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateCommitment) {
            self.dateCommitment = Utils.dateFromService(stringDate: stringDate)
        }
        if let stringDate = try container.decodeIfPresent(String.self, forKey: .dateRealSolution) {
            self.dateRealSolution = Utils.dateFromService(stringDate: stringDate)
        }
    }
    
    init(actionId: Int, action: String, dateCommitment: Date?, dateRealSolution: Date?) {
        self.traceId = -1
        self.answerId = -1
        self.action = action
        self.dateCommitment = dateCommitment
        self.dateRealSolution = dateRealSolution
        self.actionId = actionId
    }
}
