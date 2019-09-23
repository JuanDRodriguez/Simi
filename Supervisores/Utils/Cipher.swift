//
//  Chiper.swift
//  Supervisores
//
//  Created by Sharepoint on 21/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CryptoSwift

class Cypher {
    static let key = "aSq01yp5rYGerXn43400rtVTYyTrygF0"
    static let iv = "091RrtybdSAwSsAp"

    static func encrypt(text: String)->String?{
        do {
            let aes = try AES(key: Cypher.key, iv: Cypher.iv)
            let ciphertext = try aes.encrypt(Array(text.utf8))
            let data = NSData(bytes: ciphertext, length: ciphertext.count)
            let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            return base64String
        } catch {
            print("ERROR !!! \(error)")
            return nil
        }
    }
    static func decrypt(text: String)->String?{
        do {
            let aes = try AES(key: Cypher.key, iv: Cypher.iv)
            var arrayBytes : [UInt8] = []
            if let nsdata1 = Data(base64Encoded: text, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                let arr2 = nsdata1.withUnsafeBytes {
                    Array(UnsafeBufferPointer<UInt8>(start: $0, count: nsdata1.count/MemoryLayout<UInt8>.size))
                }
                arrayBytes = arr2
            }
            let bytesDecrypted = try aes.decrypt(arrayBytes)
            let data = NSData(bytes: bytesDecrypted, length: bytesDecrypted.count)
            let base64DesString = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let decodedData = Data(base64Encoded: base64DesString)!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            return decodedString
        } catch {
            print("ERROR !!! \(error)")
            return nil
        }
    }
}
