//
//  SimpleStorageProtocol.swift
//  Supervisores
//
//  Created by Sharepoint on 5/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

protocol SimpleStorageProtocol: class {
    func saveOption(option: Any, key: String)
    func getOption(key: String)->Any?
}
