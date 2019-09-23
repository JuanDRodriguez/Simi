//
//  BreachReasonSubOptions.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/12/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension BreachReasonView: UITextFieldDelegate, BreachLevelVMProtocol {
    func checkSuboptions(height: Int, width: Int) {
        guard let suboptions = self.option[KeysOptionQuestion.arraySubOptions.rawValue] as? [[String: Any]] else {return}
        if suboptions.count == 0 {
            self.bottomListConstraint.constant = 0
            self.viewBreaches.isHidden = true
            return
        }
        self.viewContetScroll.isHidden = true
        self.hasSuboptions = true
        var yPos = 5
        let heightText = 44
        for suboption in suboptions {
            let textField = UITextField(frame: CGRect(x: 5, y: yPos, width: (width - 15), height: heightText))
            textField.setLeftPaddingPoints(5)
            textField.setRightPaddingPoints(5)
            textField.placeholder = suboption[KeysSuboptionOption.description.rawValue] as? String
            textField.backgroundColor = .white
            textField.text = suboption[KeysSuboptionOption.answer.rawValue] as? String
            textField.layer.cornerRadius = 8
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1
            if let tag = suboption[KeysSuboptionOption.id.rawValue] as? Int {
                textField.tag = tag
            }
            self.scrollContainer.addSubview(textField)
            yPos += 49
        }
//        self.scrollTexts.frame = self.viewBreaches.bounds
        self.scrollContainer.contentSize = CGSize(width: 0, height: CGFloat((heightText + 5) * suboptions.count))
//        self.viewBreaches.addSubview(self.scrollTexts)
        let maxSize = Int(Double(height) * 0.75)
        if heightText * suboptions.count >  maxSize {
            self.scrollSize += CGFloat(maxSize) + 5.0
        } else {
            self.scrollSize += CGFloat(heightText * suboptions.count)
        }
    }
    
    func getBreachError(error: Error) {
        print("ERROR \(error)")
    }
    
    func getBreachLevel(levels: [[String : Any]]) {
        self.arrayBreachOptions = levels
        let arrayStrings: [String] = self.arrayBreachOptions.map({
        guard let breachName = $0[KeysBreachLevel.name.rawValue] as? String else {return " "}
            return breachName
        })
        self.checkOptionsPicker(options: arrayStrings)
    }
}
