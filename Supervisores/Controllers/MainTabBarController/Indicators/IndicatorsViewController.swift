//
//  IndicatorsViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 30/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class IndicatorsViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    var model: ModelInput!
    var lottieView : LottieViewController?
    var typeIndicator: Indicators!
    var auxIndicator: Indicators!
    var idLocation: Int  = 0
    var from = fromBuild.resumenIndicators
    lazy var contentView: viewInput = { return view as! viewInput }()
    var unit: [String: Any]
    
    init(unit: [String: Any]){
        self.unit = unit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.unit = [:]
        super.init(coder: aDecoder)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar.isHidden = false
         contentView.reloadCollectionView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //print("CountCatalogue:\(IndicatorCatalog.shared.Catalogue.count)")
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        contentView.dataSource = IndicatorCollectionViewDataSource()
        model.loadStates(indicator: .negocioTotal)
        typeIndicator = .negocioTotal
        auxIndicator = .negocioTotal
        var nameUnit = ""
        if let name = self.unit[KeysUnit.name.rawValue] as? String {
            nameUnit = name
        }
        CommonInit.navBArInitMainTabBar(vc: self, navigationBar: self.navBar, title: nameUnit)
        
       configActions()
        model.load(idLevel: typeIndicator.rawValue , idLocation: 0)
        lottieView?.animationLoading()
       
    }
    
    func configActions()  {
        
        contentView.itemAction = {
            self.lottieView?.animationLoading()
            self.model.load(idLevel: $1.rawValue, idLocation: $0)
            
        }
        contentView.itemActionShowSearBar = {
            self.navBar.isHidden = $0
        }
        contentView.itemActionOption = {
           
            self.present($0, animated: true, completion: nil)
        }
        contentView.itemActionShowMenu = {
            if $0 == 1 {
                self.idLocation = $2
                let vc = MenuLevelPopUp()
                vc.delegate = self
                self.addChild(vc)
                vc.view.frame = 
                $1.contentCollections.frame
                vc.view.frame.origin.y = 0
                $1.contentCollections.addSubview(vc.view)
                vc.self.didMove(toParent: self)
            }
            else{
                let vc = OderIndicatorPopUp()
                vc.delegate = self
                self.addChild(vc)
                vc.view.frame =
                    $1.frame
                
                $1.addSubview(vc.view)
                vc.self.didMove(toParent: self)
            }
        }
        contentView.itemActionShowDetail = {
            let detailIndicator = DetailIndicatorsViewController()
            let model = DetailIndicatorModel()
            model.out = detailIndicator
           detailIndicator.model = model
            detailIndicator.titleH = $1
            if self.typeIndicator == Indicators.unit || self.typeIndicator == Indicators.gerencia{
            detailIndicator.from = fromBuild.unitIndicators
                
            }else{
              detailIndicator.from = fromBuild.resumenIndicators
            }
           
            model.load(id: $0,typeIndicator: self.typeIndicator)
             self.present(detailIndicator, animated: true, completion: nil)
        }
        contentView.itemActionShowDetailUnit = {
            let detailIndicator = DetailIndicatorsViewController()
            let model = DetailIndicatorModel()
            model.out = detailIndicator
            detailIndicator.model = model
            detailIndicator.titleH = $1
            detailIndicator.from = fromBuild.unitIndicators
            self.typeIndicator = .unit
            model.load(id: $0,typeIndicator: self.typeIndicator)
            self.present(detailIndicator, animated: true, completion: nil)
        }
        contentView.itemActionShowIndicadorUnit = {
            self.typeIndicator = .unit
            
            self.model.loadUnit(unit: $0)
        }
        contentView.itemActionCancel = {
            self.typeIndicator = self.auxIndicator
        }
        contentView.itemActionShowDetailContacto = {
            let detailIndicator = DetailIndicatorsViewController()
            let model = DetailIndicatorModel()
            model.out = detailIndicator
            detailIndicator.model = model
            detailIndicator.titleH = $1
                detailIndicator.from = fromBuild.unitIndicators
            model.load(cuenta: $0,typeIndicator: self.typeIndicator)
            self.present(detailIndicator, animated: true, completion: nil)
        }
    }
}

extension IndicatorsViewController: ModelOutput{
    func modelDidLoad(_ items: [ContactoItem]) {
        if items.count > 0{
            contentView.display(items, typeIndicators: typeIndicator)
            self.lottieView?.animationFinishCorrect()
        }else{
            self.lottieView?.animationFinishError()
        }
    }
    
    func modelDidLoad(_ items: [IndicatorResumItem]) {
        if items.count > 0{
        contentView.display(items, typeIndicators: typeIndicator)
        self.lottieView?.animationFinishCorrect()
        }else{
            self.lottieView?.animationFinishError()
        }
    }
    
    func modelDidFail() {
        self.lottieView?.animationFinishError()
        self.typeIndicator = auxIndicator
        contentView.closeMenuLevel()
    }
    
    func modelDidLoad(_ items: [Unit], from: Int) {
       
        if from == 1 {
             navBar.isHidden = true
            contentView.displaySeachUnit(items, typeIndicators: self.typeIndicator)
            
        }
        else{
             navBar.isHidden = false
            self.lottieView?.animationFinishCorrect()
        contentView.displey(items, typeIndicators: self.typeIndicator)}
        
    }
    func modelDidLoad(_ items: [States]) {
        contentView.displey(items)
    }
}
extension IndicatorsViewController: MenuLevelDelegate{
    func selectedMenuLevel(level: Indicators) {
        self.auxIndicator = typeIndicator
        if level != .unit{
            self.lottieView?.animationLoading()
            typeIndicator = level
             model.loadStates(indicator: level)
        }else{
            contentView.showFilter()
           typeIndicator = auxIndicator
        }
        
        
        
      
        navBar.isHidden = false
             model.load(idLevel: level.rawValue, idLocation: idLocation)
        
    }
    func close(){
        contentView.closeMenuLevel()
        }
}
extension IndicatorsViewController: OrderIndicatorDelegate{
    func orderIndicators(typeOrder: TypeOrder) {
       
        model.loadOrder(typeOrder: typeOrder)
    }
    
    
}
