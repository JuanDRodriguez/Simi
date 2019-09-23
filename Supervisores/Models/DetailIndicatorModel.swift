//
//  DetailIndicatorModel.swift
//  Supervisores
//
//  Created by Sharepoint on 7/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class DetailIndicatorModel: DetailModelInput  {
    var pivote24: Double!
    var pivote26: Double!
    func load(cuenta: String, typeIndicator: Indicators) {
        NetworkingServices.shared.getIndicadors(id: "\(cuenta)/\(self.getEndPointUrl(typeIndicator: typeIndicator))"){  [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
                self.out.modelDidFail()
                return
            }
            
            guard let data = $0 else {
                _ = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                //self.reportErrorToListeners(error: error)
                self.out.modelDidFail()
                return
            }
            do{
                let items = try JSONDecoder().decode([IndicatorItem].self, from: data)
                if items.count == 0{
                    self.out.modelDidFail()
                    return
                }
                self.allIndicators = self.getIndicatorDetail(items: items)
                self.out.modelDidLoad(self.allIndicators)
                
            }
            catch let error{
                print("DescriPError: \(error.localizedDescription)")
                self.out.modelDidFail()
                return
            }
        }
    }
    
    var mounths: [String] = ["no", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    var out: DetailModelOutput!
    var allIndicators:IndicatorDetail!
    var branchIndicators: IndicatorDetail!
    var franchiseIndicators: IndicatorDetail! {
        didSet{
            
        }
    }
    var typeIndicator: Indicators!
    var negocioTotal = 0
    func load(id: Int,typeIndicator: Indicators) {
        self.typeIndicator = typeIndicator
        if typeIndicator == .negocioTotal {
            negocioTotal = 0
            request(id: 1, typeIndicator:typeIndicator)
            request(id: 2, typeIndicator:typeIndicator)
            request(id: 3, typeIndicator:typeIndicator)
        }else  if typeIndicator == .direccion {
            switch id {
            case 7:
                request(id: 7, typeIndicator:typeIndicator)
                request(id: 1, typeIndicator:typeIndicator)
                request(id: 4, typeIndicator:typeIndicator)
                break
            case 8:
                request(id: 8, typeIndicator:typeIndicator)
                request(id: 2, typeIndicator:typeIndicator)
                request(id: 5, typeIndicator:typeIndicator)
                break
            case 9:
                request(id: 9, typeIndicator:typeIndicator)
                request(id: 3, typeIndicator:typeIndicator)
                request(id: 6, typeIndicator:typeIndicator)
                break
            default:
                break
            }
        }
        else{
            request(id: id, typeIndicator: typeIndicator)
        }
    }
    func loadChangeSymbol(type: typePharmacy) {
        switch type {
        case .all:
            out.modelDidLoad(allIndicators.indicatorsGraph, mounts: allIndicators.mounths)
            break
        case .branch:
            out.modelDidLoad(branchIndicators.indicatorsGraph, mounts: branchIndicators.mounths)
            break
        case .franchise:
            out.modelDidLoad(franchiseIndicators.indicatorsGraph, mounts: franchiseIndicators.mounths)
            break
        default:
            break
        }
    }
    func loadTypePharmacy(type: typePharmacy) {
        switch type {
        case .all:
            out.modelDidLoad(allIndicators)
            break
        case .branch:
            out.modelDidLoad(branchIndicators)
            break
        case .franchise:
            out.modelDidLoad(franchiseIndicators)
            break
        default:
            break
        }
    }
    
    

    func request(id: Int, typeIndicator: Indicators) {
        DispatchQueue.main.async {
            NetworkingServices.shared.getIndicadors(id: "\(id)/\(self.getEndPointUrl(typeIndicator: typeIndicator))"){  [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
                self.out.modelDidFail()
                return
            }
            
            guard let data = $0 else {
                _ = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                //self.reportErrorToListeners(error: error)
                self.out.modelDidFail()
                return
            }
            do{
                let items = try JSONDecoder().decode([IndicatorItem].self, from: data)
                if items.count == 0{
                    self.out.modelDidFail()
                  return
                }
                if typeIndicator == Indicators.negocioTotal {
                switch id{
                case 1:
                    self.allIndicators = self.getIndicatorDetail(items: items)
                    self.negocioTotal += 1
                    if self.negocioTotal == 3{
                        self.out.modelDidLoad(self.allIndicators)
                    }
                    break
                case 2:
                    self.branchIndicators = self.getIndicatorDetail(items: items)
                    
                    Operation.statusS = self.branchIndicators.indicatorsGraph.count
                    self.negocioTotal += 1
                    if self.negocioTotal == 3{
                        self.out.modelDidLoad(self.allIndicators)
                    }
                    break
                case 3:
                    self.franchiseIndicators = self.getIndicatorDetail(items: items)
                    Operation.statusF = self.franchiseIndicators.indicatorsGraph.count
                    self.negocioTotal += 1
                    if self.negocioTotal == 3{
                        self.out.modelDidLoad(self.allIndicators)
                    }
                    break
                default:
                    break
                    
                    }}
                
                else if typeIndicator == .unit || typeIndicator == .gerencia {
                     if User.currentProfile == .manager{
                        var itemedit = items[0]
                    itemedit.IndicadorId = 4
                    itemedit.Nombre = "Calificacion de la Unidad"
                    itemedit.Valor = Double.random(in: 13...100)
                    }
                    
                    if User.currentProfile == .franchisee {
                        
                    }
                    self.allIndicators = self.getIndicatorDetail(items: items)
                    self.out.modelDidLoad(self.allIndicators)
                }else if typeIndicator == .direccion{
                    switch id{
                    case 7,8,9:
                        self.allIndicators = self.getIndicatorDetail(items: items)
                        self.out.modelDidLoad(self.allIndicators)
                        break
                    case 1,2,3:
                        self.branchIndicators = self.getIndicatorDetail(items: items)
                        
                        Operation.statusS = self.branchIndicators.indicatorsGraph.count
                        break
                    case 4,5,6:
                        self.franchiseIndicators = self.getIndicatorDetail(items: items)
                        Operation.statusF = self.franchiseIndicators.indicatorsGraph.count
                        break
                        
                    default:
                        break
                        
                    }
                }
                else{
                    if User.currentProfile == .manager{
                        if User.typeUnit == 1{
                            var itemedit = items[0]
                            itemedit.IndicadorId = 5
                            itemedit.Nombre = "Calificacion de la Gerencia"
                            itemedit.Valor = Double.random(in: 13...100)
                        }
                        if User.typeUnit == 2{
                            var itemedit = items[0]
                            itemedit.IndicadorId = 5
                            itemedit.Nombre = "Calificacion del Contacto"
                            itemedit.Valor = Double.random(in: 13...100)
                        }
                        
                    }
                    
                    if User.currentProfile == .franchisee {
                        if User.typeUnit == 2{
                            var itemedit = items[0]
                            itemedit.IndicadorId = 5
                            itemedit.Nombre = "Calificacion del Contacto"
                            itemedit.Valor = Double.random(in: 13...100)
                        }
                    }
                    let items = self.getArrayIndicatorsFromType(items: items)
                    self.allIndicators = items.0
                    self.branchIndicators = items.1
                    self.franchiseIndicators = items.2
                    Operation.statusF = self.franchiseIndicators.indicatorsGraph.count
                    Operation.statusS = self.branchIndicators.indicatorsGraph.count
                    self.out.modelDidLoad(self.allIndicators)
                    
                }
            }
            catch let error{
                print("DescriPError: \(error.localizedDescription)")
                self.out.modelDidFail()
                return
            }
        }
        }
    }
    func setUNewUmbrales(item: IndicatorDetail,type: Int) -> IndicatorDetail?{
       let catalog = IndicatorCatalog.shared.Catalogue.filter { $0.IndicadorId == 24 || $0.IndicadorId == 26   }
        let indicators = item.indicatorsTable
        var catlogos = item.indicatorStyle
        for i  in 0 ..< indicators.count{
            for catal in  catalog  {
                if indicators[i].IndicadorId == catal.IndicadorId{
                    
                    if indicators[i].IndicadorId == 24{
                        let value = indicators[i].Valor / pivote24
                        catlogos[i].Umbrales = Operation.getUmbral(items: catal.Umbrales!, item: value)
                    }else{
                        let value = indicators[i].Valor / pivote26
                        catlogos[i].Umbrales = Operation.getUmbral(items: catal.Umbrales!, item: value)
                    }
                    
                }
            }
        }
        
        return IndicatorDetail.init(indicatorsTable: indicators, indicatorStyle: catlogos, indicatorsGraph: item.indicatorsGraph, mounths: item.mounths)
    }
    
}
