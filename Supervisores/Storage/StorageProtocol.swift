//
//  StorageProtocol.swift
//  Supervisores
//
//  Created by Sharepoint on 28/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
protocol StorageProtocol: class {
    func saveModules(listModules:[Module])
    func getModules()->[Module]
    func deleteModules()
    func getNotas(idUnit: Int32) -> [NotasItem]
    func saveNota(nota: NotasItem)
    func updateNotas(nota: NotasItem)
    func getEncuestas() -> [EncuestaStoreItem]
    func updateEncuestas(items:EncuestasItem, count: Int)
    func getMensajes() -> [MensajeStoreItem]
    func updateMensaje(item: MessageItem, count: Int)
    func deleteNota(nota: NotasItem)
    func getProfile() -> (Int, Int)
    func setProfile(currentProfile: Int,lastProfile: Int)
    func saveQuestions(listQuestions: [Question], idModule: Int, isEditing: Bool)
    func getQuestions(module: Int)->[Question]
    func getResponseQuestion(id: Int32)->ResponseQuestion?
    func getResponseOption(idOption: Int32)->ResponseOption?
    func deleteCurrentSupervision(isEditing: Bool, creatingNewSupervision: Bool)
    func completeCurrentSupervision()
    func startSupervision(supervisionData: SupervisionData)->Bool
    func updateResponseModule(module:Module)
    func updateResponseQuestion(question: Question, isEditing: Bool)
    func updateOptionResponse(option: OptionQuestion, idQuestion: Int, isEditing: Bool)
    func updateSuboption(suboption: SubOption, optionId: Int, isEditing: Bool)
    func updateResponseBreach(breach: Breach, optionId: Int, isEditing: Bool)
    func savePhoto(photo: String, position: Int, questionId: Int, isEditing: Bool)
    func deletePhoto(position: Int, questionId: Int)
    
    func saveNewPause(idReason: Int, descReason: String)
    func updateLastPause()
    
    func getCurrentSupervision()->(SupervisionData)
    func getPauses()->[PauseSupervision]
    func getAllAnswers()->[AnswerSupervision]
    func getOptionStored(idOption : Int)->OptionStored?
    func getResponseBreach(idBreach: Int)->ResponseBreach?
}
