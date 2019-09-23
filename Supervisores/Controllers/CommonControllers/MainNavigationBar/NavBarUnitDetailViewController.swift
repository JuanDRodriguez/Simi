//
//  NavBarUnitDetailViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class NavBarUnitDetailViewController: UIViewController {
    @IBOutlet weak var btnNotas: UIBarButtonItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    var vc: NotasViewController!
    var navBartitle: String = ""
    init(title: String, vc: NotasViewController){
        super.init(nibName: nil, bundle: nil)
        self.navBartitle = title
        self.vc = vc
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.topItem?.title = self.navBartitle
        btnBack.setBackgroundImage(UIImage(named: "back"), for: .normal, barMetrics: .default)
        btnNotas.setBackgroundImage(UIImage(named: "Notas"), for: .normal, barMetrics: .defaultPrompt)
    }
    
    @IBAction func goToNotas(_ sender: Any) {
       
        self.present(self.vc, animated: true, completion: nil)
    }
    @IBAction func dissmisDetailUnit(_ sender: Any) {
        NotificationCenter.default.post(name: .closeDetailUnit, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
