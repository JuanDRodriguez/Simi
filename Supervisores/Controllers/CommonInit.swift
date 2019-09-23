//
//  CommonInit.swift
//  Supervisores
//
//  Created by Sharepoint on 21/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class CommonInit: NSObject {
    static func navBArInitMainTabBar(vc: UIViewController, navigationBar: UIView, title: String){
        let controller = NavBarViewController(title: title)
        controller.view.frame = navigationBar.bounds
        vc.addChild(controller)
        navigationBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
        vc.navigationController?.isNavigationBarHidden = true
    }
    static func navBArIndicators(vc: UIViewController, navigationBar: UIView, title: String){
        let controller = NavBarIndicators(title: title)
        controller.view.frame = navigationBar.bounds
        vc.addChild(controller)
        navigationBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
        vc.navigationController?.isNavigationBarHidden = true
    }
    
    static func navBarUnitDetail(vc: UIViewController, navigationBar: UIView, title: String, vController: NotasViewController ){
        let controller = NavBarUnitDetailViewController(title: title,vc: vController)
        controller.view.frame = navigationBar.bounds
        vc.addChild(controller)
        navigationBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
        vc.navigationController?.isNavigationBarHidden = true
    }
    static func navBarGenericBack(vc: UIViewController, navigationBar: UIView, title: String){
        let controller = UnitDetailNavBarViewController(title: title)
        controller.view.frame = navigationBar.bounds
        vc.addChild(controller)
        navigationBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
        vc.navigationController?.isNavigationBarHidden = true
    }

    static func navBArInSupervision(vc: UIViewController, navigationBar: UIView, title: String)->InSupervisionViewController{
        
        let controller = InSupervisionViewController(title: title)
        controller.view.frame = navigationBar.bounds
        vc.addChild(controller)
        navigationBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
        vc.navigationController?.isNavigationBarHidden = true
        return controller
    }
    
    static func navBArInitSupervision(vc: UIViewController, navigationBar: UIView, title: String)->SupervisionNavBarViewController{
        let controller = SupervisionNavBarViewController(title: title)
        controller.view.frame = navigationBar.bounds
        vc.addChild(controller)
        navigationBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
        vc.navigationController?.isNavigationBarHidden = true
        return controller
    }
    
    static func searchBarInit(vc: UIViewController, searchBar: UIView)->SearchBarViewController{
        let controller = SearchBarViewController()
        controller.view.frame = searchBar.bounds
        vc.addChild(controller)
        searchBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
        return controller
    }
    
    static func qrViewInit(vc: UIViewController, searchBar: UIView,delegate: ShowMenuOperationQr
        ){
        let controller = QRViewController()
        controller.delegate = delegate
        controller.view.frame = searchBar.bounds
        vc.addChild(controller)
        searchBar.addSubview(controller.view)
        controller.didMove(toParent: vc)
    }
    
//    static func driveViewInit(vc: UIViewController, view: UIView) -> DriveOptionsViewController{
//        let controller = DriveOptionsViewController()
//        controller.view.frame = view.bounds
//        vc.addChild(controller)
//        view.addSubview(controller.view)
//        controller.didMove(toParent: vc)
//        return controller
//    }
    
    static func lottieViewInit(vc: UIViewController ) -> LottieViewController{
        let controller = LottieViewController()
        controller.view.frame = vc.view.bounds
        vc.addChild(controller)
        vc.view.addSubview(controller.view)
        controller.didMove(toParent: vc)
        return controller
    }
}
