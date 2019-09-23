//
//  Login+Delegates.swift
//  Supervisores
//
//  Created by Sharepoint on 5/7/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController: LoginVMProtocol {
    @IBAction func changeText(_ sender: UITextField) {
       self.checkEnabled()
    }
    func checkEnabled(){
        let userName = self.userName.text?.count ?? 0 > 0
        let password = self.password.text?.count ?? 0 > 0
        
        self.btnLogin.isEnabled = userName && password
        self.btnLogin.alpha = self.btnLogin.isEnabled ? 1.0 : 0.5
    }
    func loginOk() {
        self.lottieView?.animationFinishCorrect()
        if IndicatorCatalog.shared.Catalogue.count == 0 {
            IndicatorCatalog.shared.setCatalog()
        }
        if Privileges.shared.privileges.count == 0 && Privileges.shared.privilegesProfile.count == 0{
            Privileges.shared.getPrivileges(id: 1)
            Privileges.shared.getPrivileges(id: 2)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            let appVC = MainTabBarViewController()
            self.present(appVC, animated: true, completion: nil)
        }
    }
    func loginError() {
        self.lottieView?.animationFinishError()
    }
}
