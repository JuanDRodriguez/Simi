//
//  SimpleStorage.swift
//  Supervisores
//
//  Created by Sharepoint on 5/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

enum SimpleStorageKeys: String {
    case tokenType = "AccessTokenType"
    case tokenExpiration = "AccessTokenExpiration"
    case userID = "UserInfoId"
    case name = "UserName"
    case lastName = "UserInfoLastName"
    case middleName = "UserInfoMiddleName"
    case domainAccount = "UserDomainAccount"
    case email = "UserInfoEmail"
    case saveImages = "SaveImagesInDevice"
    case showAlerts = "ShowAlerts"
    case profileId = "UserCurrentProfileId"
    case profile = "UserCurrentProfile"
}

import Foundation

class SimpleStorage: SimpleStorageProtocol {
    func saveOption(option: Any, key: String) {
        UserDefaults.standard.set(option, forKey: key)
    }
    
    func getOption(key: String) -> Any? {
        return UserDefaults.standard.value(forKeyPath: key)
    }
}
