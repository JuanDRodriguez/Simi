//
//  NavBarIndicators.swift
//  Supervisores
//
//  Created by Sharepoint on 8/27/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class NavBarIndicators: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    var navBartitle: String = ""
    init(title: String){
        super.init(nibName: nil, bundle: nil)
        self.navBartitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = navBartitle
    }

    @IBAction func goToProfile(_ sender: Any) {
        let profile = MyProfileViewController()
        self.present(profile, animated: true, completion: nil)
    }
    @IBAction func dissmisDetailUnit(_ sender: Any) {
        NotificationCenter.default.post(name: .closeDetailUnit, object: nil)
        self.dismiss(animated: true, completion: nil)
    }

}
