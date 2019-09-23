//
//  SecureStorageProtocol.swift
//  Supervisores
//
//  Created by Sharepoint on 5/7/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
protocol SecureStorageProtocol: class {
    func saveUserNPassword(userName: String, password: String)
    func getUserNPassword()->(String?, String?)
    func deleteUserNPassword()
    func saveToken(token: String)
    func getToken()->String?
    func deleteToken()
}
