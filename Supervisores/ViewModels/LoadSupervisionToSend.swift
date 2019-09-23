//
//  LoadSupervisionToSend.swift
//  Supervisores
//
//  Created by Sharepoint on 26/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class LoadSupervisionToSend {
    static let shared = LoadSupervisionToSend()
    func getSupervisionToSend(complete: Bool, isVisit: Bool, completion: @escaping([String: Any])->Void) {
        //      {
        //        "FechaInicio": "2019-03-26T16:29:28.544Z",
        //        "FechaFin": "2019-03-26T16:29:28.544Z",
        //        "UsuarioId": 0,
        //        "Latitud": 0,
        //        "Longitud": 0,
        //        "UnidadNegocioId": 0,
        //        "Visita": true,
        //        "Nocturna": true,
        //        "Completa": true,
        //        "Extras": [],
        //        "Respuestas": [],
        //        "Pausa": [],
        //      }
        
        
         let supervisionData = Storage.shared.getCurrentSupervision()
        
         let location = CommonData.getCurrentLocation()
        guard let dateStart = supervisionData.dateStart else {
            completion([:])
            return
        }
        
        let userId = Storage.shared.getOption(key: SimpleStorageKeys.userID.rawValue) as? Int ?? -1
        let answers = Storage.shared.getAllAnswers()
        let pauses = self.getPauses()
        
        self.getAnswers(answers: answers, item: (supervisionData.idUnit, "Supervicion",Utils.stringFromDateNowName())) {
            let supervisionObject : [String : Any] =
                ["FechaInicio": Utils.stringFromDateService(date: dateStart),
                 "FechaFin": Utils.stringFromDateService(date: Date()),
                 "UsuarioId": userId,
                 "Latitud": location?.coordinate.latitude ?? 0,
                 "Longitud": location?.coordinate.longitude ?? 0,
                 "UnidadNegocioId": supervisionData.idUnit,
                 "Visita": isVisit,
                 "Nocturna": false,
                 "Completa": complete,
                 "Terminada": true,
                 "Extras": self.getExtras(answers: answers),
                 "Pausa": pauses,
                 "Respuestas": $0]
            completion(supervisionObject)
        }
    }
    
    func getExtras(answers: [AnswerSupervision])->[[String: Any]] {
//        "Extras": [
//          {
//              "Comentario": "string",
//              "OpcionesIds": [
//                  0
//              ],
//              "Fotografias": [ {
//                  "Url": "string"
//              }]
//          }
//        ]
        var extrasDicto: [[String: Any]] = []
        var arrayQuestions: [Int] = answers.map({$0.questionId})
        arrayQuestions = Array(Set(arrayQuestions))
        for questionId in arrayQuestions {
            let arrayOptions = answers.filter({$0.questionId == questionId})
            let arrayOptionsId : [Int] = arrayOptions.map({$0.optionSelected})
            let dicto: [String : Any] = [
                "Comentario": arrayOptions[0].comment,
                "OpcionesIds": arrayOptionsId
            ]
            extrasDicto.append(dicto)
        }
        return extrasDicto
    }
    
    func getAnswers(answers: [AnswerSupervision],item:(Int,String,String), completion: @escaping([[String: Any?]])->Void) {
        //        "Respuestas": [
        //          {
        //              "OpcionId": 0,
        //              "ComentarioId": 0,
        //              "IncumplimientoRespuestas": [],
        //              "SubRespuestas": [],
        //              "Seguimientos": [],
        //              "Fotografias": []
        //        }
        //      ],
        var answersDicto : [[String: Any?]] = []
         for answer in answers {
            self.getPhotos(photos: answer.photos, questionId: answer.questionId, item: item) {
                let dicto: [String : Any?] = [
                    "OpcionId": answer.optionSelected,
                    "ComentarioId": nil,
                    "IncumplimientoRespuestas": self.getBreaches(breaches: answer.breachAnswers),
                    "SubRespuestas": self.getSubAnswers(subAnwers: answer.subAnswers),
                    "Seguimientos": self.getTraces(dateCommitment: answer.dateCommitment, actionId: answer.actionId),
                    "Fotografias": $0
                ]
                answersDicto.append(dicto)
                if answersDicto.count == answers.count {
                    completion(answersDicto)
                }
            }
        }
    }
    
    func getBreaches(breaches: [BreachAnswers])->[[String: Any?]]{
        //      "IncumplimientoId": 0,
        //      "NivelIncumplimiento": "string",
        //      "FechaCompromiso": "2019-03-12T15:12:25.858Z",
        //      "FechaRealSolucion": "2019-03-12T15:12:25.858Z"
        let breachesDicto: [[String: Any?]] = breaches.map({
            var commitDate = ""
            var realDate:String?
            if let date = $0.dateCommitment { commitDate = Utils.stringFromDateService(date: date) }
            if let date = $0.dateSolutionReal { realDate = Utils.stringFromDateService(date: date) }
            if realDate == nil{
                realDate = nil
            }
            let dicto:[String: Any?] = [
                "IncumplimientoId": $0.breachId,
                "NivelIncumplimientoId": $0.breachLevelId != -1 ? $0.breachLevelId : nil,
                "FechaCompromiso": commitDate,
                "FechaRealSolucion": realDate
            ]
            return dicto
        })
        return breachesDicto
    }
    
    func getSubAnswers(subAnwers: [SubAnswers])->[[String: Any]]{
        //      {
        //         "SubopcionOpcionId": 0,
        //         "Descripcion": 0
        //      }
        let subAnswDicto: [[String: Any]] = subAnwers.map({
            let dicto:[String: Any] = [
                "SubopcionOpcionId": $0.subAnswerId,
                "Descripcion": $0.description,
                ]
            return dicto
        })
        return subAnswDicto
    }
    
    func getTraces(dateCommitment: Date?, actionId: Int)->[[String: Any?]] {
        //      {
        //          "FechaCompromiso": "2019-03-12T15:12:25.858Z",
        //          "FechaRealSolucion": "2019-03-12T15:12:25.858Z",
        //          "AccionId": int
        //     }
        if actionId > 0{
            let dateCommitment: Date = dateCommitment ?? Date(timeIntervalSince1970: 0)
            let strDate = Utils.stringFromDateService(date: dateCommitment)
            let dicto:[String: Any?] = [
                "AccionId": actionId,
                "FechaCompromiso": strDate,
                "FechaRealSolucion": nil
            ]
            var tracesDicto: [[String: Any?]] = []
            tracesDicto.append(dicto)
            return tracesDicto
        }
        return []
    }
    
    func getPhotos(photos:[Photo], questionId: Int,item:(Int,String,String), completion: @escaping([[String: Any]])->Void) {
        //      {
        //          "Url": "string"
        //      }
        var arrPhotos : [[String: Any]] = []
        var imagesFromQuestion : [UIImage] = []
        for photo in photos {
            let image = Utils.base64ToImage(base64String: photo.base64Photo)
            imagesFromQuestion.append(image)
        }
        if imagesFromQuestion.count == 0 {
            completion([])
            return
        }
        NetworkingServices.shared.uploadImage(images: imagesFromQuestion, clave:item.0 ,date:item.2 ,tipo:item.1 ) {
            if let error = $1 {
                print("ERROR ==> \(error)")
                return
            }
            if let dataPhoto = $0 {
                do {
                    let decoder = JSONDecoder()
                    let photoUpload = try decoder.decode(PhotoUpload.self, from: dataPhoto)
                    for url in photoUpload.urlImage {
                        let dicto:[String: Any] = [
                            "Url": url
                        ]
                        arrPhotos.append(dicto)
                    }
                    completion(arrPhotos)
                } catch let error {
                    print("ERROR == PHOTOS>> \(error)")
                }
            } else {
                return
            }
        }
    }
    
    func getPauses()->[[String: Any]] {
        //        "Pausa": [
        //          {
        //              "FechaPausa": "2019-03-12T15:12:25.858Z",
        //              "FechaReanudacion": "2019-03-12T15:12:25.858Z",
        //              "MotivoPausaId": 0
        //          }
        //       ]
        let pauses = Storage.shared.getPauses()
        let pausesDicto: [[String: Any]] = pauses.map({
            var startPause = ""
            var endPause = ""
            if let date = $0.dateStart { startPause = Utils.stringFromDateService(date: date) }
            if let date = $0.dateEnd { endPause = Utils.stringFromDateService(date: date) }
            let dicto:[String: Any] = ["FechaPausa": startPause,
                                       "FechaReanudacion": endPause,
                                       "MotivoPausaId": $0.pauseId]
            return dicto
        })
        return pausesDicto
    }
}
