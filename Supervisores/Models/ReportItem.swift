//
//  ReportItem.swift
//  Supervisores
//
//  Created by Sharepoint on 8/16/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct ReportItem {
    
    var modulos: [Modulos]?
    init(modulo: [Modulos]?) {
        self.modulos = modulo
    }
}
struct Preguntas{
    var tema: String?
    var supervisionId: Int?
    var id: Int?
    var name: String?
    var tipo: Int?
    var nivelIncumplimiento: Bool?
    var motivos: [MotivosIncumplimiento]?
    var sizeCell: Int
    init(supervisionId: Int?, id: Int?, name: String?, tipo:Int?,motivos:[MotivosIncumplimiento]?,sizeCell: Int, tema: String?,nivelIncumplimiento: Bool) {
        self.supervisionId = supervisionId
        self.name = name
        self.id = id
        self.tipo = tipo
        self.motivos = motivos
        self.sizeCell = sizeCell
        self.tema = tema
        self.nivelIncumplimiento = nivelIncumplimiento
    }
}
struct Modulos{
    var nombre: String?
    var id: Int?
    var fechaInicio: String?
    var fechaFin: String?
     var preguntas: [Preguntas]?
     var sizeCell: Int
    init(nombre: String?, id: Int?, fechaInicio: String?, fechaFin: String?, preguntas: [Preguntas]?,sizeCell: Int) {
        self.nombre = nombre
        self.id = id
        self.fechaInicio = fechaInicio
        self.fechaFin = fechaFin
        self.preguntas = preguntas
       self.sizeCell = sizeCell
    }
}
struct MotivosIncumplimiento {
    var id: Int?
    var descripcion: String?
    var nivelIncumplimiento: String?
    var fechaSolucion: String?
    var fechaCompromiso: String?
    var status: String?
    var idRespuesta: Int?
   
    init(id: Int?,descripcion: String?,nivelIncumplimiento: String?, fechaSolucion: String?,fechaCompromiso: String?,status: String?, idRespuesta: Int?) {
        self.id = id
        self.descripcion = descripcion
        self.nivelIncumplimiento = nivelIncumplimiento
        self.fechaSolucion = fechaSolucion
        self.fechaCompromiso = fechaCompromiso
        self.status = status
        self.idRespuesta = idRespuesta
    }
}
