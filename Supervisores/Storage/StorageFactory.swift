//
//  StorageFactory.swift
//  Supervisores
//
//  Created by Sharepoint on 28/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum StorageOptions{
    case coreData
}

enum SecureStorageOptions{
    case keychanWrapper
}

enum SimpleStorageOptions {
    case userDefaults
}

class StorageFactory : NSObject{
    
    func buildStorage(storageType : StorageOptions) -> StorageProtocol {
        switch storageType {
        case .coreData:
            return CoreDataStorage()
        }
    }
}

class SecureStorageFactory : NSObject{
    func buildStorage(storageType : SecureStorageOptions) -> SecureStorageProtocol {
        switch storageType {
        case .keychanWrapper:
            return SecureStorage()
        }
    }
}

class SimpleStorageFactory : NSObject{
    func buildStorage(storageType : SimpleStorageOptions) -> SimpleStorageProtocol {
        switch storageType {
        case .userDefaults:
            return SimpleStorage()
        }
    }
}
