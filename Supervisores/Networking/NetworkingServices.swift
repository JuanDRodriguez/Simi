//
//  NetworkingServices.swift
//  Supervisores
//
//  Created by Sharepoint on 23/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

enum EndPoints : String {
    case URL_BASE = "http://200.34.206.100:8443/SupervisionDmz"//Dev
    //case URL_BASE = "http://200.34.206.118:8443/Supervision"//QA
    //case URL_BASE = "https://supervision-ventas.farmaciasdesimilares.com.mx/SupervisionWebApi" // Prod
    case getToken = "/Identity/oauth2/token"
    case getMyUnits = "/dmz/v1/UnidadNegocio/relatedTo/"
    case getAllUnits = "/dmz/v1/UnidadNegocio"
    case searchUnits = "/dmz/v1/UnidadNegocio/like"
    case getModules = "/dmz/v1/Modulos"
    case getQuestions = "/dmz/v1/Pregunta/assignedTo/"
    case getPauseReasons = "/dmz/v1/MotivoPausa"
    case sendSupervision = "/dmz/v1/Supervision/create"
    case sendMailSuboption = "/dmz/v1/Opcion/correoSubOpcion/"
    case pdfSupervision = "/dmz/v1/Reporte/"
    case getSupervision = "/dmz/v1/Supervision/"
    case getUnitInfo = "/dmz/v1/UnidadNegocio/info/"
    case getBreachLevel = "/dmz/v1/NivelIncumplimiento"
    case getActions = "/dmz/v1/Accion"
    case getSupervisionLapse = "/dmz/v1/PeriodoSupervision"
    case getSupervisionByUnit = "/dmz/v1/Supervision/unidad/"
    case getAllBusiness = "/dmz/v1/Indicadores/"
    case getAllCatalog = "/dmz/v1/Indicadores/catalogo"
    case getGroupData = "/dmz/v1/UnidadNegocio/groupData"
    case getPrivileges = "/dmz/v1/Privilegio"
    case getPrivilegesProfile = "/dmz/v1/Privilegio/pxp"
    case getReason = "/dmz/v1/Motivo"
    case getGeneralClose = "/dmz/v1/CierreGeneral"
    case postVisit = "/dmz/v1/Visita/create"
    case getVisit = "/dmz/v1/Visita/last/"
    case postReport = "/dmz/v1/Incumplimiento/update"
    case getIncumplimientos = "/dmz/v1/Incumplimiento/estatus"
    case getEncuestas = "/dmz/v1/Encuesta"
    case getEncuesta = "/dmz/v1/Encuesta/"
    case getContacto = "/dmz/v1/Contacto"
    case postEncuesta = "/dmz/v1/Encuesta/register"
    
    case getMessage = "/dmz/v1/Mensaje"
    case getWeighingRange = "/dmz/v1/RangoPonderacion/"
    case postEncuestasUsuario = "/dmz/v1/Encuesta/encuestaUsuario"
    case getScore = "/dmz/v1/Encuesta/score/"
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

class NetworkingServices {
    static var shared = NetworkingServices()
    
    
    lazy var networkingCore : NetworkingProtocol = { NetworkingFactory().buildNetworkingCore(networkingType: .urlSession) }()
     lazy var networkingCore2 : NetworkingProtocol = { NetworkingFactory().buildNetworkingCore(networkingType: .urlSession) }()
    func getToken()->String {
        if let tokenSaved = Storage.shared.getToken() {
//            print("bearer \(tokenSaved)")
            return "bearer \(tokenSaved)"
        }
        return ""
    }
    
//    , clientId : String = "0347f38c6c4643c7ad07cf2b0d5d3acb"
    func getToken(userName: String, password: String,
                  completionHandler : @escaping (Data? , Error?) -> Void) {
        let parameters : [String : Any] = [
            "Username": userName,
            "Password": password
        ]
        networkingCore.makeCall( urlEndPoint: "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getToken.rawValue)",
            httpMethod: .post,
            parameters: parameters,
            token: nil,
            completion :{completionHandler($0, $1) })
    }
    func getIndicadors(id: String, completionHandler: @escaping (Data?, Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getAllBusiness.rawValue)\(id)"
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: self.getToken(),
                                 completion :{completionHandler($0, $1) })
       
        
    }
    
    func getEncuesta(id: Int, completionHandler: @escaping (Data?, Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getEncuesta.rawValue)\(id)/preguntas"
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: self.getToken(),
                                 completion :{completionHandler($0, $1) })
        
        
    }
    func getGroupData(idLevel:Int, idLocation: Int, completionHandler: @escaping (Data?,Error?) -> Void ){
        var  urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getGroupData.rawValue)?nivel=\(idLevel)&locacion=\(idLocation)"
        if idLevel == 8{
            urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getContacto.rawValue)"
        }
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: self.getToken(),
                                 completion :{completionHandler($0, $1) })
    }
    func getCatalog(completionHandler: @escaping (Data?, Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getAllCatalog.rawValue)"
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: self.getToken(),
                                 completion :{completionHandler($0, $1) })
    }
    func getEncuestas(completionHandler: @escaping (Data?, Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getEncuestas.rawValue)"
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: self.getToken(),
                                 completion :{completionHandler($0, $1) })
    }
    func getGeneralClose(completionHandler: @escaping (Data?, Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getGeneralClose.rawValue)"
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: self.getToken(),
                                 completion :{completionHandler($0, $1) })
    }
    func getPrivileges(id: Int,completionHandler: @escaping (Data?, Error?) -> Void){
        let urlEndPoint = id == 1 ?  "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getPrivileges.rawValue)": "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getPrivilegesProfile.rawValue)"
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: self.getToken(),
                                 completion :{completionHandler($0, $1) })
    }
    func getVisit(idUnit: Int,completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getVisit.rawValue)\(idUnit)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getIncumplimientos(completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getIncumplimientos.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getMessage(completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getMessage.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getMyUnits(id: String,completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getMyUnits.rawValue)\(id)"
        let token = self.getToken()
        let net = URLSessionsNetworking()
        net.makeCall( urlEndPoint: urlEndPoint,
                      httpMethod: .get,
                      parameters: nil,
                      token: token,
                      completion :{completionHandler($0, $1) })
        
    }
    
    func getAllUnits(completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getAllUnits.rawValue)"
        let token = self.getToken()
        DispatchQueue.main.async {
            self.networkingCore2.makeCall( urlEndPoint: urlEndPoint,
                                     httpMethod: .get,
                                     parameters: nil,
                                     token: token,
                                     completion :{completionHandler($0, $1) })
        }
        
    }
    
    func searchUnits(criteria: String, completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.searchUnits.rawValue)?query=\(criteria)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getReasons(completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getReason.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
        
    func postReports(param: [[String: Int]],completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.postReport.rawValue)"
        print(param)
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .post,
                                 parameters: param,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func posEncuestas(param: [String: Any],completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.postEncuesta.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .post,
                                 parameters: param,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func postEncuestasUsuario(param: [String: Any],completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.postEncuestasUsuario.rawValue)"
        let token = self.getToken()
        print(param)
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .post,
                                 parameters: param,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getScore(id: String,completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getScore.rawValue)\(id)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getModules(completionHandler : @escaping (Data? , Error?) -> Void){
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getModules.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func getQuestions(idModule: Int, completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getQuestions.rawValue)\(idModule)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func getPauseReasons(completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getPauseReasons.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func postSupervision(supervisionInfo:[String: Any], completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.sendSupervision.rawValue)"
        let token = self.getToken()
       print("jsonSupervicion: \(supervisionInfo)")
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .post,
                                 parameters: supervisionInfo,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func postVisit(supervisionInfo:[String: Any], completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.postVisit.rawValue)"
        let token = self.getToken()
         print("jsonVisit: \(supervisionInfo)")
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .post,
                                 parameters: supervisionInfo,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getSupervision(supervisionId: Int, completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getSupervision.rawValue)\(supervisionId)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func sendMailSuboption(arraySuboptions: [[String: String]], unitId:Int, optionId: Int, completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.sendMailSuboption.rawValue)\(unitId)/\(optionId)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .post,
                                 parameters: arraySuboptions,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func getUnitInfo(unitId: Int, completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getUnitInfo.rawValue)\(unitId)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func getBreachLevel(completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getBreachLevel.rawValue)"        
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func getActions(completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getActions.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func getSupervisionLapse(completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getSupervisionLapse.rawValue)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func getSupervisionByUnit(unitId: Int, completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getSupervisionByUnit.rawValue)\(unitId)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    func getWeighingRange(type: String, completionHandler : @escaping (Data? , Error?) -> Void) {
        let urlEndPoint = "\(EndPoints.URL_BASE.rawValue)\(EndPoints.getWeighingRange.rawValue)\(type)"
        let token = self.getToken()
        networkingCore.makeCall( urlEndPoint: urlEndPoint,
                                 httpMethod: .get,
                                 parameters: nil,
                                 token: token,
                                 completion :{completionHandler($0, $1) })
    }
    
    func uploadImage(images: [UIImage],clave: Int, date: String, tipo: String, completion: @escaping (Data?, Error?) -> Void) {
       // networkingCore.uploadImage(images: images, question: question, completion: completion)
        networkingCore.uploadImage(images: images, clave: clave, date: date, tipo: tipo, completion: completion)
    }
}
