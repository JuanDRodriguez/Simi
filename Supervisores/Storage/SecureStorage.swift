//
//  SecureStorage.swift
//  Supervisores
//
//  Created by Sharepoint on 5/7/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import KeychainAccess

class SecureStorage: SecureStorageProtocol {
    let keychain = Keychain(service: "com.FDS.Supervisores.Supervisores")
    func saveUserNPassword(userName: String, password: String) {
        do {
            try keychain.set(userName, key: "userName")
            try keychain.set(password, key: "password")
        }
        catch let error {
            print(error)
        }
    }
    func saveToken(token: String) {
        do {
            try keychain.set(token, key: "access-Token")
        }
        catch let error {
            print(error)
        }
    }
    func getToken()->String? {
        let token = keychain["access-Token"]
        return token
    }
    func deleteToken(){
        do {
            try keychain.remove("access-Token")
        }
        catch let error {
            print(error)
        }
    }
    func getUserNPassword()->(String?, String?) {
        let userName = keychain["userName"]
        let password = keychain["password"]
        return (userName, password)
    }
    func deleteUserNPassword(){
        do {
            try keychain.remove("userName")
            try keychain.remove("password")
        }
        catch let error {
            print(error)
        }
    }
}
