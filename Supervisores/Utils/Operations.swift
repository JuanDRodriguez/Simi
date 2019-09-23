//
//  Operations.swift
//  Supervisores
//
//  Created by Sharepoint on 7/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
enum Indicators: Int {
    case negocioTotal = 1
    case direccion = 2
    case estado = 3
    case ciudad = 4
    case municipio = 5
    case unit = 6
    case gerencia = 7
    case contacto = 8
    
}
enum TypeOrder{
    case name
    case yearToYear
}
enum Option{
    case optionIndicator
    case order
    case search
}
enum fromBuild{
    case resumenIndicators
    case unitIndicators
}
enum typeOperationStore {
    case supervision
    case visita
    case encuesta
}
enum QrOperation{
    case no
    case yes
}
enum typeOperationQR{
    case visita
    case supervision
}
enum infoUser: String {
    case activo = "Activo"
    case correoElectronico = "CorreoElectronico"
    case cuentaDominio = "CuentaDominio"
    case nombreCompleto = "NombreCompleto"
    case numeroEmpleado = "NumeroEmpleado ";
    case perfil = "Perfil";
    case perfilId = "PerfilId";
    case usuarioId = "UsuarioId";
}
struct Operation {
    static var statusF = 0
    static var statusS = 0
    static var clave: String = ""
    static var starts: Int = 0
    static func getUmbral(id: Int,value: Double) -> String{
        
        var item = IndicatorCatalog.shared.Catalogue.filter({
            $0.IndicadorId == id
        })
        guard let umbrales = item[0].Umbrales else {
            return "#808080"
        }
        var color = umbrales.filter({
            ($0.ValorMaximo! > value) && ($0.ValorMinimo! < value)
        })
        var  umbral: String!
        if color.count == 0 {
           umbral = "#808080"
        }
        else {
        umbral = color[0].Color
        }
        return umbral
    }
    static func getUmbral(items : [UmbralItem], item: Double) -> [UmbralItem]{
        var umbral: [UmbralItem] = []
        for i in 0 ..< items.count {
            let min = Double(items[i].ValorMinimo!)
            let max = Double(items[i].ValorMaximo!)
            if items[i].Activo!{
                if (min <= item) && (max >= item) {
                    umbral.append(items[i])
                }
            }
        }
        return umbral
    }
    static func getIndicatorsString(type: Indicators) -> String{
        switch type {
        case .negocioTotal:
            return "NEGOCIO TOTAL"
           
        case .direccion:
           return "DIRECCIÓN"
            
        case .estado:
            return "ESTADO"
           
        case .ciudad:
            return "CIUDAD"
           
        case .municipio:
            return "MUNICIPIO"
          
        case .unit:
            return "UNIDADES"
        
            
        case .gerencia:
            return "GERENCIA"
        case .contacto:
            return "CONTACTO"
        }
    }
    static func getPrivilageforId( idPrivilege: Int) -> Bool{
        var aux  = false
        for i in 0 ..< Privileges.shared.privilegesProfile.count{
            if Privileges.shared.privilegesProfile[i].PrivilegioId == idPrivilege{
                aux = Privileges.shared.privilegesProfile[i].Activo!
            }
        }
        return aux
    }
    static func getJsonOffQR(type: typeOperationStore,id: Int) -> [String : Any]{
        let user = LoginViewModel.shared.loginInfo!
        let unit = UnitsMapViewModel.shared.arrayAllUnits.filter({
            $0.id == id
        })
        if type == .supervision{
        
        print(unit.count)
        let jsonUser: [String: Any] = [infoUser.activo.rawValue: user.user?.active,
                                       infoUser.correoElectronico.rawValue: "",
                                       infoUser.cuentaDominio.rawValue: user.user?.domainAccount,
                                       infoUser.nombreCompleto.rawValue: user.user?.name,
                                       infoUser.numeroEmpleado.rawValue: 054105,
                                       infoUser.perfil.rawValue:user.user?.profile,
                                       infoUser.perfilId.rawValue:user.user?.profileId,
                                       infoUser.usuarioId.rawValue:user.user?.userId]
        let json : [String : Any] = [KeysQr.keyUnit.rawValue: unit[0].key,
                                     KeysQr.nameUnit.rawValue: unit[0].name,
                                     KeysQr.supervisorKey.rawValue:"",
                                     KeysQr.timeStamp.rawValue: "",
                                     KeysQr.type.rawValue:"Supervision",
                                     KeysQr.typeUnit.rawValue: unit[0].type == 1 ? "Sucursal":"Fanquicia",
                                     KeysQr.unitId.rawValue:unit[0].id,
                                     KeysQr.userInfo.rawValue: jsonUser]
        
        return json
        }else{
            let json : [String : Any] = ["UnidadNegocioId": unit[0].id,
                                         "UsuarioID": LoginViewModel.shared.loginInfo?.user?.userId,
                                         "latitud":unit[0].lat,
                                         "longitud": unit[0].lng]
            return json
        }
        
    }
    
    func getProfileString(profile: Profiles) -> String{
        switch profile {
        case .administrator:
            return "Administrator"
        case .director:
            return "Director"
        case .directorStaff:
            return "DirectorStaff"
        case .franchisee:
            return "Franquiciatario"
        case .general:
            return "General"
        case .manager:
            return "Gerente"
        case .supervisor:
            return "Supervisor"
        case .NA:
            return ""
        }
    }
    static func getReports(item: ResumeSupervision,modules:[Module]) -> ReportItem{
        var report: ReportItem!
         var motivosA: [MotivosIncumplimiento] = []
        var preguntas: [Preguntas] = []
        var modulos: [Modulos] = []
        var tema = ""
        var idModule = 0
        var nombre = ""
        var dateSolution = ""
        var dateCompromiso = ""
        var sizeModulo = 150
        for i in 0 ..< modules.count {
            let auxPreguntas = item.answers.filter({$0.moduleId == (i + 1) && $0.breaches.count > 0 })
            preguntas = []
        for pregunta in auxPreguntas{
            motivosA = []
            
            for motivo in pregunta.breaches{
                //dateSolution = Utils.stringFromDate(date: motivo.dateRealSolution!)
                dateCompromiso = Utils.stringFromDate(date: motivo.dateCommitment!)
                if dateCompromiso == "31-12-1969"{
                    dateCompromiso = ""
                }
                motivosA.append(MotivosIncumplimiento.init(id: motivo.breachId, descripcion: motivo.description, nivelIncumplimiento: motivo.breachLevel, fechaSolucion: dateSolution, fechaCompromiso: dateCompromiso, status: motivo.status,idRespuesta:  motivo.answerId))
                //print("id: \(motivo.breachId)date: \(dateCompromiso)")
            }
            let size =  150 + (60 * motivosA.count)
            if size > sizeModulo {
                sizeModulo =  size
            }
            preguntas.append(Preguntas.init(supervisionId: pregunta.supervisionId, id: pregunta.questionId, name: pregunta.questionDescription, tipo: pregunta.optionId, motivos: motivosA, sizeCell: size,tema: pregunta.topic,nivelIncumplimiento: pregunta.nivelIncumplimiento))
           nombre = pregunta.module
            idModule = pregunta.moduleId
            
            }
            if preguntas.count > 0{
                
                    modulos.append(Modulos.init(nombre:nombre ,  id: idModule, fechaInicio:Utils.stringFromDate(date: item.dateInit!), fechaFin: Utils.stringFromDate(date:item.dateEnd!), preguntas: preguntas, sizeCell: sizeModulo))
            }
            sizeModulo = 150
        }
        report = ReportItem.init(modulo: modulos)
        return report
    }
   
}


