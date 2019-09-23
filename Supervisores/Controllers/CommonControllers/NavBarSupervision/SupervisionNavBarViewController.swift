//
//  SupervisionNavBarViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 05/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class SupervisionNavBarViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var btnProfile: UIBarButtonItem!
    @IBOutlet weak var btnLogo: UIBarButtonItem!
    
    var navBartitle: String = ""
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.navBartitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitle(newTitle: String){
        self.navBartitle = newTitle
        if self.navBar != nil {
            self.navBar.topItem?.title = self.navBartitle
        }
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
