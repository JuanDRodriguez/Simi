//
//  DetailOrderModel.swift
//  Supervisores
//
//  Created by Sharepoint on 7/11/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
extension DetailIndicatorModel{
    
    
    func getStyleToindicators(indicators: [IndicatorItem]) -> [CatalogIndicatorItem]{
        var items = IndicatorCatalog.shared.Catalogue
        var catalog: [CatalogIndicatorItem] = []
        for i in 0 ..< indicators.count {
            for j in 0 ..< items.count {
                if indicators[i].IndicadorId == items[j].IndicadorId{
                    items[j].Umbrales = Operation.getUmbral(items: items[j].Umbrales!, item: indicators[i].Valor)
                    catalog.append(items[j])
                }
                
            }
        }
        return catalog
    }
    func getItemsByDivision(items:[IndicatorItem]) -> [[IndicatorItem]] {
        var itemsDivision: [[IndicatorItem]] = [[],[],[]]
        for i in 0 ..< items.count {
            if items[i].Division != nil{
            switch items[i].Division!{
            case "T":
                let indicator = items[i]
                itemsDivision[0].append(indicator)
                break
            case "S":
                let indicator = items[i]
                itemsDivision[1].append(indicator)
                break
            case "F":
                let indicator = items[i]
                itemsDivision[2].append(indicator)
                break
            default:
                break
            }
            }}
        return itemsDivision
    }
    func getIndicatorNote(){
        
    }
    func getIndicatorDetail(items:[IndicatorItem]) -> IndicatorDetail{
        if items.count > 0{
            
            let catalog = self.getStyleToindicators(indicators: items)
            let graph = self.getIndicadorsGraph(indicators: items, style: catalog)
            let itemTwo = self.orderIndicators(indicators: items, style: catalog)
            let m = self.getMounths(items: graph)
            return IndicatorDetail.init(indicatorsTable: quickSort(array: itemTwo.0), indicatorStyle:itemTwo.1 , indicatorsGraph: graph, mounths:m )
        }else{
            return IndicatorDetail.init(indicatorsTable: [], indicatorStyle:[] , indicatorsGraph: [], mounths: [] )
        }
        
    }
    func getIndicadorsGraph(indicators: [IndicatorItem], style: [CatalogIndicatorItem]) -> [IndicatorItem]{
        var items:[IndicatorItem] = []
        for i in 0 ... 6 {
            if i != 3{
                items.append(indicators[i])
            }
            
        }
        return items
    }
    func showIndicator(item: CatalogIndicatorItem) -> Bool {
        switch User.currentProfile {
        case .administrator:
             return item.Director
            break
        case .director:
           return item.Director
            break
        case .directorStaff:
            return item.DirectorStaff
            break
        case .franchisee:
            return item.Franquiciatario
            break
        case .general:
            return item.Director
            break
        case .manager:
            return item.Gerente
            break
        case .supervisor:
            return item.Supervisor
            break
            case .NA:
            return item.Gerente
    }
    }
    func orderIndicators(indicators: [IndicatorItem], style: [CatalogIndicatorItem]) ->([IndicatorItem],[CatalogIndicatorItem])  {
        var items: [IndicatorItem] = []
        var sty: [CatalogIndicatorItem] = []
        for i in 0 ..< indicators.count {
            for j in 0 ..< style.count {
                if (i + 1) == style[j].Orden && style[j].Visible == true {
                    if  style[j].Grafica == false && showIndicator(item: style[j]) == true{
                        if typeIndicator == Indicators.unit {
                            if style[j].Agrupado == false{
                                if indicators[j].IndicadorId == 42{
                                    if String(indicators[j].Anio) == Utils.stringFromDateYear(){
                                        items.append(indicators[j])
                                        sty.append(style[j])
                                    }
                                }else{
                                    items.append(indicators[j])
                                    sty.append(style[j])
                                }
                                
                            }
                        }else{
                        
                            if style[j].Agrupado{
                                items.append(indicators[j])
                                sty.append(style[j])
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
        return (items,sty)
    }
    func getMounths(items: [IndicatorItem]) -> [String]{
        var mounths: [String] = []
        if items.count == 0{
            return mounths
        }
        for i in 0 ... 2 {
            mounths.append(self.mounths[items[i].Mes])
           
        }
        return mounths
    }
    func getEndPointUrl(typeIndicator: Indicators) -> String{
        var url = ""
        switch typeIndicator {
        case .negocioTotal:
            url = "nt"
            break
        case .direccion:
            url = "d"
            break
        case .estado:
            url = "e"
            break
        case .ciudad:
            url = "c"
            break
        case .municipio:
            url = "m"
            break
        case .unit:
            url = "un"
            break
        case .contacto:
            url = "cto"
            break
        default:
            url = "g"
            break
        }
        return url
    }
    func getArrayIndicatorsFromType(items: [IndicatorItem]) -> (IndicatorDetail,IndicatorDetail,IndicatorDetail){
        let itemsDivision = getItemsByDivision(items: items)
        
        return (getIndicatorDetail(items: itemsDivision[0]),getIndicatorDetail(items: itemsDivision[1] ),getIndicatorDetail(items: itemsDivision[2]))
    }
    func quickSort(array: [IndicatorItem]) -> [IndicatorItem] {
        if array.isEmpty { return [] }
        
        let first = array.first!
        
        let smallerOrEqual = array.dropFirst().filter { $0.Orden <= first.Orden }
        let larger         = array.dropFirst().filter { $0.Orden > first.Orden }
        
        return quickSort(array: smallerOrEqual) + [first] + quickSort(array: larger)
    }
    
}
