//
//  UnitDetailNavBarViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 30/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class UnitDetailNavBarViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var navBartitle: String = ""
    init(title: String){
        super.init(nibName: nil, bundle: nil)
        self.navBartitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitle(newTitle: String) {
        self.navBartitle = newTitle
        self.navBar.topItem?.title = self.navBartitle
    }
    
    func showBackButton(showed: Bool = true){
        
        self.backButton.isEnabled = showed
        
        if showed {
            self.backButton.setBackgroundImage(UIImage(named: "back"), for: .normal, barMetrics: .default)
        } else {
            self.backButton.setBackgroundImage(UIImage(named: "back-disabled"), for: .normal, barMetrics: .default)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.topItem?.title = self.navBartitle
        self.backButton.setBackgroundImage(UIImage(named: "back"), for: .normal, barMetrics: .default)
    }
    @IBAction func dissmisDetailUnit(_ sender: Any) {
        NotificationCenter.default.post(name: .closeDetailUnit, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
