//
//  MyProfileViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 5/7/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var switchStoredPhotos: UISwitch!
    @IBOutlet weak var btnCloseSession: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = Storage.shared.getOption(key: SimpleStorageKeys.name.rawValue),
           let middleName = Storage.shared.getOption(key: SimpleStorageKeys.middleName.rawValue),
            let lastName = Storage.shared.getOption(key: SimpleStorageKeys.lastName.rawValue) {
            self.lblName.text = "\(name) \(middleName) \(lastName)"
        }
        let (userName, _) = Storage.shared.getUsernameNPassword()
        if let userN = userName{
            self.lblUserName.text = "\(userN)"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let saveImg = Storage.shared.getOption(key: SimpleStorageKeys.saveImages.rawValue) as? Bool {
            switchStoredPhotos.isOn = saveImg
        }
        if let notifications = Storage.shared.getOption(key: SimpleStorageKeys.showAlerts.rawValue) as? Bool {
            switchNotification.isOn = notifications
        }
    }
    @IBAction func dissmissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func changeNotifications(_ sender: Any) {
        if let bntSwitch = sender as? UISwitch {
            Storage.shared.saveOption(option: bntSwitch.isOn, key: SimpleStorageKeys.showAlerts.rawValue)
        }
    }
    @IBAction func changeStorePhoto(_ sender: Any) {
        if let bntSwitch = sender as? UISwitch {
            Storage.shared.saveOption(option: bntSwitch.isOn, key: SimpleStorageKeys.saveImages.rawValue)
        }
    }
    @IBAction func closeSession(_ sender: Any) {
        Storage.shared.deleteUserNPassword()
        Storage.shared.deleteToken()
        MyUnitsViewModel.shared.arrayUnits = []
        MyUnitsViewModel.shared.arrayUnitsMaped = []
        MyUnitsViewModel.shared.arrayUnitsOrderFilter = []
        SupervisionModulesViewModel.shared.modulesList = []
        PauseReasonsViewModel.shared.arrayReasons = []
        PauseReasonsViewModel.shared.reasonsList = []
        Storage.shared.deleteCurrentSupervision(isEditing: false)
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func legalAdvice(_ sender: Any) {
        let legalView = LegalViewController()
        self.present(legalView, animated: true)
    }
}
