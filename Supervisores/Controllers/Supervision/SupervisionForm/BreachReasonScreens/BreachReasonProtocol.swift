//
//  BreachReasonProtocol.swift
//  Supervisores
//
//  Created by Sharepoint on 13/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

enum BreachReasonType {
    case normal
    case dates
}

protocol BreachReasonAnswerProtocol: class {
    func formComplete(complete: Bool, moveView: Bool)
    func updateSuptions(optionID: Int)
}

protocol BreachReasonProtocol {
    var breachReasonView : UIView! { get }
    var delegate: BreachReasonAnswerProtocol? {get set}
    func showKeyBoard(sizeHeight : CGFloat)
    func getComment()->String
    func getAction()->(Int, String)
    func getDateSolutionCommon()->Date?
}
