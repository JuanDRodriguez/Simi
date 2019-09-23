//
//  IndicatorItem.swift
//  Supervisores
//
//  Created by Sharepoint on 7/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
struct IndicatorItem: Decodable {
    var IndicadorUnidadNegocioId: Int?
    var UnidadNegocioId: Int?
    var IndicadorId: Int
    var IndicadorNegocioTotalId: Int?
    var NegocioTotalId: Int?
    var Nombre: String
    var Mes: Int
    var Anio: Int
    var Valor : Double
    var Division : String?
    var Orden: Int
}
struct IndicatorDetail {
    var indicatorsTable : [IndicatorItem]
    var indicatorsGraph: [IndicatorItem]
    var indicatorStyle: [CatalogIndicatorItem]
    var mounths: [String]
    init(indicatorsTable: [IndicatorItem], indicatorStyle: [CatalogIndicatorItem] , indicatorsGraph: [IndicatorItem], mounths: [String]) {
        self.indicatorsTable = indicatorsTable
        self.indicatorStyle = indicatorStyle
        self.indicatorsGraph = indicatorsGraph
        self.mounths = mounths
    }
}
struct IndicatorResumItem: Decodable {
    var Franquicias: Int?
    var Indicador16: Indicador16?
    var Nivel: String?
    var Laboratorios: Int?
    var LocacionId: Int?
    var Nombre: String?
    var Total: Int?
    var Sucursales: Int?
    
}
struct Indicador16: Decodable {
    var Valor: Double?
    var Umbral: String?
}
