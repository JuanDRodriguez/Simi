//
//  EncuestasViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 8/29/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class EncuestasViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    
    var lottieView : LottieViewController?
    
    lazy var contentView: EncuentasViewInput = {return view as! EncuentasViewInput}()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lottieView = CommonInit.lottieViewInit(vc: self)
       CommonInit.navBArInitMainTabBar(vc: self, navigationBar: navBar, title: "Encuestas")
        contentView.dataSource = EncuestasDataSource()
        contentView.itemAction = {
            self.openQrReader($0)
            
        }
        EncuestasModel.shared.out = self
         
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lottieView?.animationLoading()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       EncuestasModel.shared.getScore()
    }
    func openQrReader(_ item: EncuestasItem){
        let controller = QRViewController()
        controller.view.frame = view.bounds
        self.addChild(controller)
        controller.didMove(toParent: self)
        controller.type = .encuesta
        controller.encuesta = item
        controller.countEncu = 0
        controller.goToQr()
    }
}
extension EncuestasViewController: EncuestasModelOutput{
    func modelDidLoad(_ items: ([EncuestasItem],[String:Int])) {
        lottieView?.animationFinishCorrect()
        contentView.display(items)
    
    }
    
    func modelDidLoadFail() {
        lottieView?.animationFinishError()
    }
    
    
}
