//
//  InSupervisionViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 11/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class InSupervisionViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
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
        backButton.setBackgroundImage(UIImage(named: "back"), for: .normal, barMetrics: .default)
        pauseButton.setBackgroundImage(UIImage(named: "btnPause"), for: .normal, barMetrics: .default)
    }
    @IBAction func dissmisVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pauseSupervision(_ sender: Any) {
        NotificationCenter.default.post(name: .showPauseReason, object: nil)
    }
}
