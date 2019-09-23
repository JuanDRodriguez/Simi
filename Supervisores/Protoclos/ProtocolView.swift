//
//  ProtocolView.swift
//  Supervisores
//
//  Created by Sharepoint on 7/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
protocol viewInput: class{
    
    var itemAction: ((Int,Indicators) -> Void)? { get set }
    var itemActionOption: ((UIAlertController) -> Void)? { get set }
    var itemActionShowDetail: ((Int,String) -> Void)? { get set }
    var itemActionShowDetailUnit: ((Int,String) -> Void)? { get set }
    var itemActionShowMenu: ((Int,IndicatorView,Int) -> Void)? { set get }
    var itemActionShowIndicadorUnit: ((UnitLite) -> Void)? { set get }
    var itemActionShowDetailContacto:((String,String) -> Void)? {set get}
    var itemActionShowSearBar: ((Bool) -> Void )? { get set }
    var itemActionCancel: (() -> Void)? {get set}
    var dataSource: IndicatorCollectionViewDataSource! { get set }
    func displaySeachUnit(_ items: [Unit],typeIndicators:Indicators)
    func display(_ items: [IndicatorResumItem],typeIndicators: Indicators)
     func display(_ items: [ContactoItem],typeIndicators: Indicators)
    func displey(_ items: [Unit],typeIndicators:Indicators)
    func displey(_ items: [States])
    func reloadCollectionView()
    func closeMenuLevel()
    func showFilter()
    
}
protocol viewInputDetail: class {
    func display(_ items: IndicatorDetail, from: fromBuild)
    func display(_ items:  [IndicatorItem],time: [String], symbol: String)
    func display(from: fromBuild)
    var dataSource: DataSourceDetailIndicator! { set get}
    var itemAction:((typePharmacy) -> Void)? { get set }
    var formatterAction: ((String) -> Void)? { set get }
}
protocol DetailModelInput {
    func load(id: Int,typeIndicator: Indicators )
    func load(cuenta: String, typeIndicator: Indicators)
    func loadTypePharmacy(type: typePharmacy)
    func loadChangeSymbol(type: typePharmacy)
}
protocol ModelInput {
    func load(idLevel: Int, idLocation: Int)
    func loadUnit(unit:UnitLite)
    func loadOrder(typeOrder: TypeOrder)
    func loadStates(indicator: Indicators)
}
protocol DetailModelOutput: class {
    func modelDidLoad(_ items: IndicatorDetail )
    func modelDidLoad(_ items: [IndicatorItem], mounts: [String])
    func modelDidFail()
}
protocol ModelOutput: class {
    func modelDidLoad(_ items: [IndicatorResumItem])
    func modelDidLoad(_ items: [States])
    func modelDidLoad(_ items: [Unit], from: Int)
    func modelDidLoad(_ items: [ContactoItem])
    func modelDidFail()
}
protocol GeneralModelOutput: class {
    func modelDidLoad(_ items: ([String],[Service]),isFranquicia: Bool)
    func modelDidLoadFail()
}
protocol GeneralViewInput: class {
    func display(items: ([String],[Service]), isFranquicia: Bool)
    var dataSource: DataSourceGeneralInfo! {set get}
}
protocol visitViewInput: class {
    var dataSource: VisitDataSoruce! {set get}
   func display(items: [ReasonItem])
    var itemAction: ((PhotosView,[(Bool,Int)],String) ->Void)? {set get}
}
protocol visitModelInput: class{
    func load(date: Date)
    func sendVisit(photos:PhotosView,motivos:[(Bool,Int)],comentario:String,date: (Date,Date))
}
protocol visitModelOutput: class {
     func modelDidLoad(_ items: [ReasonItem])
    func modelDidLoadSend()
    func modelDidFail() 
}
protocol visitedModelOutput: class {
    func modelDidLoad(_ Items: [VisistItem])
}
protocol IncumplimientoModelOutput: class {
    func modelDidLoad(_ items: [Incumplimientositem])
}
//Mark*
protocol ReportsViewInput: class {
    func display(_ items: ReportItem)
    func displayUpdate(_ item: Int, status: String)
    var itemActionSend: (([[String: Int]]) -> Void)? {get set}
    var itemAction: (() -> Void)? {get set}
}
protocol ReportsModelInput: class {
    func load()
    func sendLoad(param:[[String:Int]])
}
protocol ReportModelOutput: class {
    func modelDidLoad(_ items: ReportItem)
    func modelDidLoadFail ()
    func modelDidLoadFinish()
}
//Mark*
protocol NotasViewInput: class {
    func display(_ items:[NotasItem])
    var dataSource: NotasDataSource! {get set}
    var itemAction: (() -> Void)? {get set}
    func display(_ name: String, direcc: String )
}
protocol NotasModelInput {
    func load(id: Int32)
    func Update(item: (Int,String,String))
    func delete(item: NotasItem)
}
protocol NotasModelOutput {
    func modelDidLoad(_ items:[NotasItem])
    func modelDidLoadFail()
}
// Mark*
protocol EncuestasModelInput {
    func load()
}
protocol EncuestaModelInput {
    func load(id: Int)
    func sendEncuesta(items:[ResponseEncuesta],photos:[PhotosView])
}
protocol EncuentasViewInput: class {
    func display(_ items: ([EncuestasItem],[String:Int]))
    var itemAction: ((EncuestasItem) -> Void)? {get set}
     var dataSource: EncuestasDataSource! {get set}
}
protocol EncuentaViewInput: class {
    func display(_ items: [Question])
    var itemAction: (([ResponseEncuesta],[PhotosView]) -> Void)? {get set}
    
}

protocol EncuestasModelOutput {
    func modelDidLoad(_ items:([EncuestasItem],[String:Int]))
    func modelDidLoadFail()
}
protocol EncuestaModelOutput {
    func modelDidLoad(_ items:[Question])
    func modelDidLoadFail()
    func modelDidLoadFinish()
}
protocol MessageModelOutput {
    func modelDidLoad(_ items:[MessageItem])
    func modelDidLoadFail()
   
}
protocol didSelectOptionCell {
    func didSelected(option: [String:Any])
}

