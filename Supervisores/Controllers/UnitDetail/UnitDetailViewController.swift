//
//  UnitDetailViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 30/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class UnitDetail: UITabBarController {
   
    var unit: [String: Any]
    var generalInfoVC : GeneralInfoViewController
    var indicatorsVC : DetailIndicatorsViewController
    var supervisionVC : SupervisionReportViewController
    var reportsVC : ReportsViewController
    var encuestasVC: EncuestasViewController
    var generalInfo : UINavigationController!
    var indicators : UINavigationController!
    var supervision : UINavigationController!
    var reports : UINavigationController!
    var encuestas: UINavigationController!
    
    var itemGeneralInfo : UITabBarItem?
    var itemIndicators : UITabBarItem?
    var itemSupervision : UITabBarItem?
    var itemReports : UITabBarItem?
    var itemEncuestas: UITabBarItem?
    let modelG = GeneralModel()
    let modelR = ReportsModel()
    let modelE = EncuestasModel()
    init(unit: [String: Any]){
        self.unit = unit
        generalInfoVC = GeneralInfoViewController(unit: self.unit)
        indicatorsVC = DetailIndicatorsViewController()
        supervisionVC = SupervisionReportViewController(unit: self.unit)
        reportsVC  = ReportsViewController(unit: self.unit)
       encuestasVC = EncuestasViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.unit = [:]
        generalInfoVC = GeneralInfoViewController(unit:[:])
        indicatorsVC = DetailIndicatorsViewController()
        supervisionVC = SupervisionReportViewController(unit: [:])
        reportsVC  = ReportsViewController(unit: [:])
        encuestasVC = EncuestasViewController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let idUnit = self.unit[KeysUnit.idUnit.rawValue] as? Int {
            PastSupervisionViewModel.shared.getSupervisionByUnit(unitId: idUnit)
        }
        generalInfo = UINavigationController.init(rootViewController: generalInfoVC)
        indicators = UINavigationController.init(rootViewController: indicatorsVC)
        supervision = UINavigationController.init(rootViewController: supervisionVC)
        reports = UINavigationController.init(rootViewController: reportsVC)
        encuestas = UINavigationController.init(rootViewController: encuestasVC)
        
        self.viewControllers = [generalInfo, indicators, supervision, reports]
        
        itemGeneralInfo = UITabBarItem(title: "Información general", image: UIImage(named: "infoGral"), tag: 0)
        itemIndicators = UITabBarItem(title: "Indicadores", image:  UIImage(named: "indicadores"), tag: 1)
        itemSupervision = UITabBarItem(title: "Supervisión", image:  UIImage(named: "iconSupervision"), tag: 2)
        itemReports = UITabBarItem(title: "Reportes", image:  UIImage(named: "reportesIcon"), tag: 3)
        itemEncuestas =   UITabBarItem(title: "Encuestas", image:  UIImage(named: "reportesIcon"), tag: 4)
        generalInfo.tabBarItem = itemGeneralInfo
        indicators.tabBarItem = itemIndicators
        supervision.tabBarItem = itemSupervision
        reports.tabBarItem = itemReports
        encuestas.tabBarItem = itemEncuestas
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor(red: 127.0/255.0, green: 187.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .gray
        NotificationCenter.default.addObserver(self, selector: #selector(dissmisTabBarController), name: .closeDetailUnit, object: nil)
       //itemEncuestas?.isEnabled = false
        let model = DetailIndicatorModel()
        model.out = indicatorsVC
        indicatorsVC.model = model
        indicatorsVC.from = fromBuild.unitIndicators
        indicatorsVC.titleH = "\(unit[KeysUnit.key.rawValue] as! String) \(unit[KeysUnit.name.rawValue] as! String)"
        model.load(id:unit[KeysUnit.idUnit.rawValue] as! Int ,typeIndicator: Indicators.unit)
       
        
        if IndicatorCatalog.shared.Catalogue.count == 0 {
            IndicatorCatalog.shared.setCatalog()
        }
        
        modelG.out = generalInfoVC
        print("\(unit)")
       modelG.load(key: unit["keyUnit"] as! String)
        modelR.out = reportsVC
        reportsVC.model = modelR
        IncumplimientoModel.shared.load()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.generalInfoVC.unit = self.unit
        self.supervisionVC.unit = self.unit
        self.reportsVC.unit = self.unit
    }
    
    @objc func dissmisTabBarController() {
       self.dismiss(animated: true, completion: nil)
    }
    
    
}
