//
//  MainTabBarViewController.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 1/20/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
protocol MainTabBarProtocol {
    func clearBadge()
}
class MainTabBarViewController: UITabBarController,ProtocolMainTabBar,MainTabBarProtocol {
    var encuestasVC: EncuestasViewController = EncuestasViewController()
    
    var unitsVC : UnitsViewController = UnitsViewController()
    var mapVC : MapViewController = MapViewController()
    var indicatorsVC:IndicatorsViewController =  IndicatorsViewController.init(unit: [:])
    var researchVC : ResearchViewController = ResearchViewController()
    var messagesVC : MessageViewController = MessageViewController()
    
    var units : UINavigationController!
    var map : UINavigationController!
    var indicators : UINavigationController!
    var research : UINavigationController!
    var messages : UINavigationController!
    var encuestas: UINavigationController!
    
    var itemUnits : UITabBarItem?
    var itemMap : UITabBarItem?
    var itemIndicators: UITabBarItem?
    var itemResearch : UITabBarItem?
    var itemMessages : UITabBarItem?
    var itemEncuestas: UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesVC.delegate = self
        units = UINavigationController.init(rootViewController: unitsVC)
        map = UINavigationController.init(rootViewController: mapVC)
        indicators = UINavigationController.init(rootViewController: indicatorsVC)
        research = UINavigationController.init(rootViewController: researchVC)
        messages = UINavigationController.init(rootViewController: messagesVC)
         encuestas = UINavigationController.init(rootViewController: encuestasVC)
        unitsVC.delegate = self
        self.viewControllers = [units, map,indicators, encuestas, messages]
        EncuestasModel.shared.load()
        itemUnits = UITabBarItem(title: "Unidades", image: UIImage(named: "unidades"), tag: 0)
        itemMap = UITabBarItem(title: "Mapa", image:  UIImage(named: "mapa"), tag: 1)
        itemIndicators = UITabBarItem(title: "Indicadores", image:  UIImage(named: "indicadores"), tag: 2)
        itemEncuestas = UITabBarItem(title: "Investigación", image:  UIImage(named: "Investigacion"), tag: 3)
        itemMessages = UITabBarItem(title: "Mensajes", image:  UIImage(named: "mensajes"), tag: 4)
        
        units.tabBarItem = itemUnits
        map.tabBarItem = itemMap
        indicators.tabBarItem = itemIndicators
        encuestas.tabBarItem = itemEncuestas
        messages.tabBarItem = itemMessages
        clearBadge()
        self.tabBar.barTintColor = UIColor(red: 53/255.0, green: 91/255.0, blue: 151/255.0, alpha: 1.0)
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMap(notification:)), name: .goToMapWithUnit, object: nil)
       
        
        let model = IndicatorModel()
        model.out = indicatorsVC
        indicatorsVC.model = model
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if User.currentProfile == .franchisee{
            itemEncuestas?.isEnabled = false
        }
        if  Operation.getPrivilageforId(idPrivilege: 11) == false{
            self.itemIndicators?.isEnabled = false
            
        }
         if  Operation.getPrivilageforId(idPrivilege: 7) == false{
            self.itemMessages?.isEnabled = false
        }
        if Operation.getPrivilageforId(idPrivilege: 10) == false{
            self.itemUnits?.isEnabled = false
            self.selectedIndex = 1
        }
       
       // self.itemIndicators?.isEnabled = true
    }
    
    @objc func goToMap(notification: NSNotification){
        guard let unit = notification.object as? [String: Any] else { return }
        self.mapVC.unitRoute = unit
        self.mapVC.ismyUnit = true
        self.selectedIndex = 1
    }
    func noUnits() {
       
    }
    func clearBadge() {
      
            itemEncuestas?.badgeValue = "\(EncuestasModel.shared.newEncuestas)"
    
             itemMessages?.badgeValue = "\(MessageModel.shared.newMessages)"
        
    }
}
protocol ProtocolMainTabBar {
    func noUnits()
}
