//
//  Storage.swift
//  Supervisores
//
//  Created by Sharepoint on 01/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class Storage {
    static var shared = Storage()
    lazy var storage : StorageProtocol = { StorageFactory().buildStorage(storageType: .coreData) }()
    lazy var secureStorage : SecureStorageProtocol = { SecureStorageFactory().buildStorage(storageType: .keychanWrapper) }()
    lazy var simpleStorage : SimpleStorageProtocol = { SimpleStorageFactory().buildStorage(storageType: .userDefaults) }()
    func getNotas(idUnit: Int32) -> [NotasItem]{
        return storage.getNotas(idUnit:idUnit)
    }
    func saveNotas(nota: NotasItem){
        storage.saveNota(nota: nota)
    }
    func getProfile() -> (Int,Int){
        return storage.getProfile()
    }
    func setProfile(currentProfile: Int,latProfile: Int){
        storage.setProfile(currentProfile: currentProfile, lastProfile: latProfile)
    }
    func updateNotas(nota: NotasItem){
        storage.updateNotas(nota: nota)
    }
    func deleteNota(nota: NotasItem){
        storage.deleteNota(nota: nota)
    }
    func getEncuestas(idUnit: Int32) -> [EncuestaStoreItem] {
        return storage.getEncuestas()
    }
    func getMensajes() -> [MensajeStoreItem]{
      return storage.getMensajes()
    }
    func updateEncuestas(item : EncuestasItem, count: Int){
        storage.updateEncuestas(items: item, count: count)
    }
    func updateMensaje(item: MessageItem, count: Int){
        storage.updateMensaje(item: item, count: count)
    }
    func completeCurrentSupervision(){
        storage.completeCurrentSupervision()
    }
    func saveModules(listModules:[Module]) {
        storage.saveModules(listModules: listModules)
    }
    func updateModule(module:Module) {
        storage.updateResponseModule(module: module)
    }
    func getModules()->[Module] {
        return storage.getModules()
    }
    func deleteModules() {
        storage.deleteModules()
    }
    func saveQuestions(listQuestions: [Question], idModule: Int, isEditing: Bool) {
        storage.saveQuestions(listQuestions: listQuestions, idModule: idModule, isEditing: isEditing)
    }
    func getQuestions(idModule: Int)->[Question] {
        return storage.getQuestions(module: idModule)
    }
    func startSupervision(supervisionData: SupervisionData)->Bool{
        return storage.startSupervision(supervisionData: supervisionData)
    }
    func getResponseQuestion(id: Int)->ResponseQuestion? {
        return storage.getResponseQuestion(id: Int32(id))
    }
    func getResponseOption(idOption: Int)->ResponseOption? {
        return storage.getResponseOption(idOption: Int32(idOption))
    }
    func updateResponseQuestion(question: Question, isEditing: Bool){
        storage.updateResponseQuestion(question: question, isEditing: isEditing)
    }
    func updateSuboption(suboption: SubOption, optionId: Int, isEditing: Bool){
        storage.updateSuboption(suboption: suboption, optionId: optionId, isEditing: isEditing)
    }
    func updateOptionResponse(option: OptionQuestion, idQuestion: Int, isEditing: Bool){
        storage.updateOptionResponse(option: option, idQuestion: idQuestion, isEditing: isEditing)
    }
    func updateResponseBreach(breach: Breach, optionId: Int, isEditing: Bool){
        storage.updateResponseBreach(breach: breach, optionId: optionId, isEditing: isEditing)
    }
    func savePhoto(photo : UIImage, position: Int, idQuestion: Int, isEditing: Bool){
        NetworkingServices.shared.uploadImage(images: [photo], clave: SupervisionViewController.unitId, date: Utils.stringFromDateNowName(), tipo: "Supervicion" ){
            if let error = $1 {
                print("ERROR ==> \(error)")
                
                return
            }
            if let dataPhoto = $0 {
                do {
                    let decoder = JSONDecoder()
                    let photoUpload = try decoder.decode(PhotoUpload.self, from: dataPhoto)
                    for url in photoUpload.urlImage {
                        self.storage.savePhoto(photo: url, position: position, questionId: idQuestion, isEditing: isEditing)
                    }
                   
                } catch let error {
                    
                    
                    print("ERROR == PHOTOS>> \(error)")
                }
            } else {
                
                return
            }
        
        }
    }
    func savePhotoString(photo : String, position: Int, idQuestion: Int, isEditing: Bool){
        self.storage.savePhoto(photo: photo, position: position, questionId: idQuestion, isEditing: isEditing)
    }
    func saveNewPause(idReason: Int, descReason: String){
        storage.saveNewPause(idReason: idReason, descReason: descReason)
    }
    func updateLastPause(){
        storage.updateLastPause()
    }
    func getCurrentSupervision()->(SupervisionData){
        return storage.getCurrentSupervision()
    }
    func deleteCurrentSupervision(isEditing: Bool, creatingNewSupervision: Bool = false){
        storage.deleteCurrentSupervision(isEditing: isEditing, creatingNewSupervision: creatingNewSupervision)
    }
    func getPauses()->[PauseSupervision]{
        return storage.getPauses()
    }
    func getAllAnswers()->[AnswerSupervision] {
        return storage.getAllAnswers()
    }
    func deletePhoto(position: Int, questionId: Int){
        storage.deletePhoto(position: position, questionId: questionId)
    }
    func getOptionStored(idOption : Int)->OptionStored?{
        return storage.getOptionStored(idOption: idOption)
    }
    func getResponseBreach(idBreach: Int)->ResponseBreach?{
        return storage.getResponseBreach(idBreach: idBreach)
    }
    func saveUsernameNPassword(username: String, password: String){
        secureStorage.saveUserNPassword(userName: username, password: password)
    }
    func deleteUserNPassword(){
        secureStorage.deleteUserNPassword()
    }
    func getUsernameNPassword()->(String?, String?){
        return secureStorage.getUserNPassword()
    }
    func saveOption(option: Any, key: String) {
        simpleStorage.saveOption(option: option, key: key)
    }
    func getOption(key: String)->Any? {
        return simpleStorage.getOption(key: key)
    }
    func saveToken(token: String) {
        secureStorage.saveToken(token: token)
    }
    func getToken()->String? {
        return secureStorage.getToken()
    }
    func deleteToken() {
        secureStorage.deleteToken()
    }
}
