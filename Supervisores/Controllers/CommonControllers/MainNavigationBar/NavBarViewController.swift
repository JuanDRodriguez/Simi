//
//  NavBarViewController.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 1/20/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class NavBarViewController: UIViewController {
    @IBOutlet weak var btnProfile: UIBarButtonItem!
    @IBOutlet weak var btnLogo: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    var navBartitle: String = ""
    init(title: String){
        super.init(nibName: nil, bundle: nil)
        self.navBartitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.topItem?.title = self.navBartitle
        btnProfile.setBackgroundImage(UIImage(named: "perfil"), for: .normal, barMetrics: .default)
        btnLogo.setBackgroundImage(UIImage(named: "simi-logo"), for: .normal, barMetrics: .default)
    }

    @IBAction func goToProfile(_ sender: Any) {
        let profile = MyProfileViewController()
        self.present(profile, animated: true, completion: nil)
    }
}
