//
//  NetworkingFactory.swift
//  Supervisores
//
//  Created by Sharepoint on 23/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

enum NetworkingConnection{
    case urlSession
}

class NetworkingFactory : NSObject{
    
    func buildNetworkingCore(networkingType : NetworkingConnection) -> NetworkingProtocol {
        switch networkingType {
        case .urlSession:
            return URLSessionsNetworking()
        }
    }
}
