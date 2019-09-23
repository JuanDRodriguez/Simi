//
//  LoginViewController.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 1/20/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var bottomLoginConstrain: NSLayoutConstraint!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewPassword: UIView!
    var lottieView : LottieViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let badgeCount: Int = 0
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = badgeCount
        self.userName.setLeftPaddingPoints(5.0)
        self.userName.setRightPaddingPoints(5.0)

        self.password.setLeftPaddingPoints(5.0)
        self.password.setRightPaddingPoints(5.0)
        
        self.btnLogin.isEnabled = false
        self.btnLogin.alpha = 0.5
        
        self.viewUserName.layer.borderWidth = 1.0
        self.viewUserName.layer.borderColor = UIColor.white.cgColor
        self.viewPassword.layer.borderWidth = 1.0
        self.viewPassword.layer.borderColor = UIColor.white.cgColor
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        LoginViewModel.shared.setListener(listener: self)
        let (userName, password) = Storage.shared.getUsernameNPassword()
        self.userName.text = ""
        self.password.text = ""
        if let userN = userName {
            self.userName.text = userN
        }
        if let pass = password {
            self.password.text = pass
        }
        self.checkEnabled()
        if let dateExpires = Storage.shared.getOption(key: SimpleStorageKeys.tokenExpiration.rawValue) as? Date {
            print("EXPIRA EN ===>> \(dateExpires)")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        LoginViewModel.shared.setListener(listener: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomLoginConstrain.constant = keyboardSize.height - 30.0
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomLoginConstrain.constant = 30.0
    }
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        self.lottieView?.animationLoading()
        guard let userN = self.userName.text else { return }
        guard let pass = self.password.text else { return }
        Storage.shared.saveUsernameNPassword(username: userN, password: pass)
        
        LoginViewModel.shared.login(user: userN, password: pass)

//        "sisrlopez"
//        "Simil@res"

//        NetworkingServices.shared.getToken(userName: userN, password: pass) {
//            if let error = $1 {
//                self.lottieView?.animationFinishError()
//                print("ERROR pp===>>> \(error)")
//            }
//            guard let data = $0 else {
//                self.lottieView?.animationFinishError()
//                return
//            }
//            let test = String(data: data, encoding: String.Encoding.utf8)
//            print("DATA!!!!!===>> \(test)")
//
//            self.lottieView?.animationFinishCorrect()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                let appVC = MainTabBarViewController()
//                self.present(appVC, animated: true, completion: nil)
//            }
//        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
