//
//  EndSupervision.swift
//  Supervisores
//
//  Created by Sharepoint on 12/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysSupervisionInfo: String {
    case supervisionId = "supervisionIdResume"
    case supervisorKey = "userKeyResume"
    case dateBegin = "dateBeginResume"
    case dateEnd = "dateEndResume"
    case userId = "userIdResume"
    case userAccount = "userAccountDomainResume"
    case latitude = "latitudeResume"
    case longitude = "longitudeResume"
    case description = "descriptionResume"
    case rate = "rateResume"
    case unitId = "unitIdResume"
}

enum KeysUnitDetailsResume: String {
    case unitId = "unitIdResume"
    case unitKey = "unitKeyResume"
    case unitName = "unitNameResume"
    case unitLat = "unitLatResume"
    case unitLng = "unitLngResume"
    case unitType = "unitTypeResume"
    case unitContact = "unitContactResume"
    case unitBussinessName = "unitBussinessNameResume"
    case unitStreet = "unitStreetResume"
    case unitNumberExt = "unitNumberExtResume"
    case unitColony = "unitColonyResume"
    case unitCity = "unitCityResume"
    case unitCP = "unitCPResume"
    case unitState = "unitStateResume"
}

enum KeysAnswerResume: String {
    case answerId = "answerIdResume" //"RespuestaId": 1,
    case comment = "answerCommentResume" //"Comentario": null,
    case commentId = "answerCommentId" //"ComentarioId": 0,
    case supervisionId = "supervisionIdAnswerResume" //"SupervisionId": 1,
    case weighing = "weighingResume" //"PonderacionOpcion": 0,
    case optionSelectedId = "optionSelectedIdResume" //"OpcionId": 1884,
    case optionDescription = "optionDescriptionResume" // "Opcion": "Cumple Todas sub",
    case questionDescription = "questionDescriptionResume" //"Pregunta": "Prueba Sub opciones",
    case questionId = "questionIdResume" //"PreguntaId": 1290
    case moduleDescription = "moduleDescriptionResume" //"Modulo": "Imagen",
    case moduleId = "moduleIdResume" //"ModuloId": 81,
    case topicDescription = "topicDescriptionResume" //"Tema": "Anaquel",
    case breaches = "breachesAnswerResume" //"IncumplimientoRespuesta": [],
    case subAnswers = "subAnswersResume" //"SubRespuesta": []
    case traces = "tracesResume" //"Seguimiento": [],
    case photos = "photosResume" //"Fotografias": []
    //    "TipoPreguntaId": 1,
    //    "MotivoId": 0,
}

enum KeysBreachAnswerDictoResume: String {
    case breachId = "breachIdResume"
    case description = "descriptionBreachResume"
    case answerId = "answerIdResume"
    case levelBreach = "levelBreachResume"
    case dateCommitment = "dateCommitmentResume"
    case dateRealSolution = "dateRealSolutionResume"
}

enum KeysSubanswerResume: String {
    case suboption = "suboptionResume"
    case description = "descriptionResume"
}

enum KeysTraceDictoResume: String {
    case trace = "traceResume"
    case answerID = "answerIdTraceResume"
    case action = "actionTraceResume"
    case dateCommitment = "dateCommitmentTraceResume"
    case dateRealSolution = "dateRealSolutionTraceResume"
}

enum KeysPhotosResume: String {
    case supervisionId = "supervisionIdPhotoResume"
    case photo = "photoResume"
}

@objc protocol EndSupervisionVMProtocol {
    func supervisionSendedError(error: Error)
    func supervisionSendedOk(idSupervision: Int, rate: Int, descriptionSupervision: String, unitName: String, keyUnit: String, unitType: Int)
}
@objc protocol GetSupervisionResumeVMProtocol {
    func supervisionSendedError(error: Error)
    func getResumeSupervision(supervisionInfo:[String: Any], unitInfo: [String: Any], answersSupervision: [[String: Any]])
}

class EndSupervision {
    static let shared = EndSupervision()
    var supervisionResume : ResumeSupervision?
    var listenerEnd: EndSupervisionVMProtocol?
    var listenerGet: GetSupervisionResumeVMProtocol?
    init() {
        
    }
    func setEndListener(listener: EndSupervisionVMProtocol?){
        self.listenerEnd = listener
    }
    func setGetResumeListener(listener: GetSupervisionResumeVMProtocol?){
        self.listenerGet = listener
    }
    func sendSuperVision(supervision: [String: Any]) {
        NetworkingServices.shared.postSupervision(supervisionInfo: supervision) {
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
            do {
                let decoder = JSONDecoder()
                self.supervisionResume = try decoder.decode(ResumeSupervision.self, from: data)
                self.listenerEnd?.supervisionSendedOk(idSupervision: self.supervisionResume?.supervisionId ?? 0,
                                                      rate: self.supervisionResume?.rate ?? 0,
                                                      descriptionSupervision: self.supervisionResume?.description ?? "",
                                                      unitName: self.supervisionResume?.unit?.unitName ?? "",
                                                      keyUnit: self.supervisionResume?.unit?.unitKey ?? "",
                                                      unitType: self.supervisionResume?.unit?.unitType ?? 1)
               print("\(decoder)")
            } catch let error {
                self.reportErrorToListeners(error: error)
            }
        }
    }
    func getInfoFromModel(supervisionResume: ResumeSupervision)->([String: Any], [String: Any], [[String: Any]]) {
        let supResume : [String: Any] = [KeysSupervisionInfo.supervisionId.rawValue: supervisionResume.supervisionId,
                                         KeysSupervisionInfo.dateBegin.rawValue: supervisionResume.dateInit ?? "",
                                         KeysSupervisionInfo.supervisorKey.rawValue: supervisionResume.supervisorKey,
                                         KeysSupervisionInfo.dateEnd.rawValue: supervisionResume.dateEnd ?? "",
                                         KeysSupervisionInfo.userId.rawValue: supervisionResume.userId,
                                         KeysSupervisionInfo.userAccount.rawValue: supervisionResume.userAccountDomain,
                                         KeysSupervisionInfo.latitude.rawValue: supervisionResume.lat,
                                         KeysSupervisionInfo.longitude.rawValue: supervisionResume.lng,
                                         KeysSupervisionInfo.rate.rawValue: supervisionResume.rate,
                                         KeysSupervisionInfo.description.rawValue: supervisionResume.description]
        
        var unitResume : [String: Any] = [:]
        if let unitDetail = supervisionResume.unit{
            unitResume = [KeysUnitDetailsResume.unitId.rawValue: unitDetail.unitId,
                          KeysUnitDetailsResume.unitKey.rawValue: unitDetail.unitKey,
                          KeysUnitDetailsResume.unitName.rawValue: unitDetail.unitName,
                          KeysUnitDetailsResume.unitLat.rawValue: unitDetail.unitLat,
                          KeysUnitDetailsResume.unitLng.rawValue: unitDetail.unitLng,
                          KeysUnitDetailsResume.unitType.rawValue: unitDetail.unitType,
                          KeysUnitDetailsResume.unitContact.rawValue: unitDetail.unitContact,
                          KeysUnitDetailsResume.unitBussinessName.rawValue: unitDetail.unitBussinesName,
                          KeysUnitDetailsResume.unitStreet.rawValue: unitDetail.unitStreet,
                          KeysUnitDetailsResume.unitNumberExt.rawValue: unitDetail.unitNumberExt,
                          KeysUnitDetailsResume.unitColony.rawValue: unitDetail.unitColony,
                          KeysUnitDetailsResume.unitCity.rawValue: unitDetail.unitCity,
                          KeysUnitDetailsResume.unitCP.rawValue: unitDetail.unitCP,
                          KeysUnitDetailsResume.unitState.rawValue: unitDetail.unitState]
        }
        let answerSupervision = self.getAnswersResume(answerResume: supervisionResume.answers)
        return (supResume, unitResume, answerSupervision)
    }
    func getAnswersResume(answerResume: [AnswerResume])->[[String: Any]] {
        var answerSupervision : [[String: Any]] = []
        var questionsChecked: [Int] = []

        for answer in answerResume {
            if questionsChecked.contains(answer.questionId) { continue }
            questionsChecked.append(answer.questionId)
            let breaches = self.breachesToDicto(breaches: answer.breaches)
            let subanswers = self.subAnswerToDicto(subAnswers: answer.subAnswers)
            let traces = self.tracesToDicto(traces: answer.traces)
            let photos = answer.photos// photosResume.filter({ $0.questionId == answer.questionId })
            let photosDictionary = self.photoToDicto(photos: photos)
            let options = answerResume.filter({$0.questionId == answer.questionId})
            let arrayOptionsDicto : [String] = options.map({
                $0.optionDescription
            })
            let dictoAnswer : [String:Any] = [  KeysAnswerResume.comment.rawValue: answer.comment,
                                                KeysAnswerResume.optionDescription.rawValue: arrayOptionsDicto,
                                                KeysAnswerResume.optionSelectedId.rawValue: answer.optionId,
                                                KeysAnswerResume.questionDescription.rawValue: answer.questionDescription,
                                                KeysAnswerResume.questionId.rawValue: answer.questionId,
                                                KeysAnswerResume.moduleDescription.rawValue: answer.module,
                                                KeysAnswerResume.moduleId.rawValue: answer.moduleId,
                                                KeysAnswerResume.topicDescription.rawValue: answer.topic,
                                                KeysAnswerResume.breaches.rawValue: breaches,
                                                KeysAnswerResume.subAnswers.rawValue: subanswers,
                                                KeysAnswerResume.traces.rawValue: traces,
                                                KeysAnswerResume.weighing.rawValue: answer.weighing,
                                                KeysAnswerResume.photos.rawValue: photosDictionary]
            answerSupervision.append(dictoAnswer)
        }
        return answerSupervision
    }
    
    func breachesToDicto(breaches: [BreachAnswerResume])->[[String: Any]]{
        var dictoBreaches : [[String: Any]] = []
        for breach in breaches {
            let breacheAnswer : [String:Any] = [  KeysBreachAnswerDictoResume.breachId.rawValue: breach.breachId,
                                                KeysBreachAnswerDictoResume.description.rawValue: breach.description,
                                                KeysBreachAnswerDictoResume.answerId.rawValue: breach.answerId,
                                                KeysBreachAnswerDictoResume.levelBreach.rawValue: breach.breachLevel,
                                                KeysBreachAnswerDictoResume.dateCommitment.rawValue: breach.dateCommitment ?? "",
                                                KeysBreachAnswerDictoResume.dateRealSolution.rawValue: breach.dateRealSolution ?? ""]
            dictoBreaches.append(breacheAnswer)
        }
        return dictoBreaches
    }
    
    func subAnswerToDicto(subAnswers: [SubAnswerResume])->[[String: Any]]{
        var dictoSubAnswers : [[String: Any]] = []
        for subanswer in subAnswers {
            let dictoSubanswer : [String:Any] = [  KeysSubanswerResume.suboption.rawValue: subanswer.subOption,
                                                  KeysSubanswerResume.description.rawValue: subanswer.description]
            dictoSubAnswers.append(dictoSubanswer)
        }
        return dictoSubAnswers
    }
    func tracesToDicto(traces: [TraceResume])->[[String: Any]]{
        var dictoTraces : [[String: Any]] = []
        for trace in traces {
            let dictoTrace : [String:Any] = [  KeysTraceDictoResume.trace.rawValue: trace.traceId,
                                                  KeysTraceDictoResume.answerID.rawValue: trace.answerId,
                                                  KeysTraceDictoResume.action.rawValue: trace.action,
                                                  KeysTraceDictoResume.dateCommitment.rawValue: trace.dateCommitment ?? "",
                                                  KeysTraceDictoResume.dateRealSolution.rawValue: trace.dateRealSolution ?? ""]
            dictoTraces.append(dictoTrace)
        }
        return dictoTraces
    }
    func photoToDicto(photos: [PhotoResume])->[[String: Any]]{
        var dictoPhotos : [[String: Any]] = []
        for photo in photos {
            let dictoPhoto : [String:Any] = [ KeysPhotosResume.photo.rawValue: photo.photo ?? photo.photoUrl]
            dictoPhotos.append(dictoPhoto)
        }
        return dictoPhotos
    }
    func sendSupervisionData(supervisionId: Int)->Bool {
        if let currentSupervision = self.supervisionResume {
            if currentSupervision.supervisionId == supervisionId {
                let (supervisionInfo, unitInfo, answersSupervision) = self.getInfoFromModel(supervisionResume: currentSupervision)
                self.listenerGet?.getResumeSupervision(supervisionInfo: supervisionInfo, unitInfo: unitInfo, answersSupervision: answersSupervision)
                return true
            }
        }
        return false
    }
    func getSupervision(supervisionId: Int) {
//        if self.sendSupervisionData(supervisionId: supervisionId){
//            return
//        }
        NetworkingServices.shared.getSupervision(supervisionId: supervisionId) {
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
                //print("ResponseGetSupervision: \(jsonResponse)") //Response result
            } catch let parsingError {
                
                print("Error", parsingError)
            }
            do {
                let decoder = JSONDecoder()
                self.supervisionResume = try decoder.decode(ResumeSupervision.self, from: data)
               // print("ModelGetSupervicion: \(String(describing: self.supervisionResume))")
                if let currentResume = self.supervisionResume {
                    let _ =  self.sendSupervisionData(supervisionId: currentResume.supervisionId)
                }
            } catch let error {
                self.reportErrorToListeners(error: error)
            }
        }
    }
    func reportErrorToListeners(error: Error) {
        self.listenerEnd?.supervisionSendedError(error: error)
        self.listenerGet?.supervisionSendedError(error: error)
    }
}
