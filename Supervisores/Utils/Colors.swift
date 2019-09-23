//
//  Colors.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/7/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    case missing
}
extension Color: RawRepresentable {
    typealias RawValue = UIColor
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case #colorLiteral(red: 0.9254902005, green: 0.07955666546, blue: 0.1252823997, alpha: 0.4595620599): self = .missing
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .missing: return #colorLiteral(red: 0.9254902005, green: 0.07955666546, blue: 0.1252823997, alpha: 0.4595620599)
        }
    }
}
