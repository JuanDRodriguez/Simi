//
//  BreachReasonFactory.swift
//  Supervisores
//
//  Created by Sharepoint on 13/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class BreachReasonFactory : NSObject {
    func buildReachReasonView(question : [String: Any], option: [String: Any]?, frameView : CGRect) -> BreachReasonProtocol? {
        let breachQ = BreachReasonView(question: question, option: option , frame: frameView)
        return breachQ
    }
}

