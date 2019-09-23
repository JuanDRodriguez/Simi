//
//  NetworkingProtocol.swift
//  Supervisores
//
//  Created by Sharepoint on 23/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case unknownError
    case dataError
    case timeOutError
    case incorrectUrl
    case parametersSerialization
    case httpResponse
}

protocol NetworkingProtocol {
    func makeCall(urlEndPoint : String, httpMethod : HTTPMethod,
                  parameters: Any?, token: String?, completion: @escaping (Data?, Error?)->Void)
    func uploadImage(images: [UIImage], clave: Int , date: String, tipo: String, completion: @escaping (Data?, Error?)->Void)
}
