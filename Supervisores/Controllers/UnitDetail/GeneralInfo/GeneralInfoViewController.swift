//
//  GeneralInfoViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 30/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class GeneralInfoViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    var lottieView : LottieViewController?
    var nameUnit = ""
    var notavc: NotasViewController!
    lazy var contentView: GeneralViewInput = { return view as! GeneralViewInput }()
    var unit: [String: Any]

    init(unit: [String: Any]){
        self.unit = unit
        print("jd:\(unit)")
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        self.unit = [:]
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.lottieView = CommonInit.lottieViewInit(vc: self)
        let model = NotasModel()
        let vc = NotasViewController()
        
        self.notavc = vc
        model.out = vc
        vc.model = model
        if let name = self.unit[KeysUnit.name.rawValue] as? String, let key  = self.unit[KeysUnit.key.rawValue] as? String{
            self.nameUnit = "\(key) \(name)"
            model.name = name
            vc.idUnit = name
            vc.nameUnit = nameUnit
        }
         model.idUnit = Int32(self.unit["idUnit"] as! Int)
        CommonInit.navBarUnitDetail(vc: self, navigationBar: self.navBar, title: nameUnit,vController: vc)
        contentView.dataSource = DataSourceGeneralInfo()
       
        
    }
}
extension GeneralInfoViewController: GeneralModelOutput{
    func modelDidLoad(_ items: ([String], [Service]),isFranquicia: Bool) {
    contentView.display(items: items,isFranquicia: isFranquicia)
         self.lottieView?.animationFinishCorrect()
        if isFranquicia {
            notavc.direccion = items.0[0]
        }else{
            notavc.direccion = items.0[1]
        }
    }
    func modelDidLoadFail() {
       self.lottieView?.animationFinishError()
    }
}
