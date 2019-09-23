//
//  BinaryQuestionBreachReason+Protocol.swift
//  Supervisores
//
//  Created by Sharepoint on 13/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension BinaryQuestionView: BreachReasonAnswerProtocol {
    func updateSuptions(optionID: Int) {
        guard let idQuestion = self.question[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard var options = self.question[KeysOptionQuestion.option.rawValue] as? [[String: Any]] else {return}
        options = options.map({
            if let idOption = $0[KeysOptionQuestion.id.rawValue] as? Int {
                if idOption == optionID {
                    var newOption = $0
                    newOption[KeysOptionQuestion.arraySubOptions.rawValue] = QuestionViewModel.shared.getSuboptions(questionId: idQuestion, optionId: optionID)
                    return newOption
                }
            }
            return $0
        })
        self.question[KeysQuestion.options.rawValue] = options
    }
    
    func formComplete(complete: Bool, moveView: Bool = true) {
        self.reachedReasonsComplete = complete
        self.isFullMode = false
        if moveView {
            if let superView = self.superview {
                UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                    self.frame.origin.y = self.questionSize
                    self.frame.size.height = superView.bounds.size.height - self.questionSize * 2
                    self.breachReason?.breachReasonView.frame.origin.y = self.bounds.size.height
                })
            }
        }
       
        self.breachReasonButton?.setBreachReasonfinish(finished: complete)
        self.delegate?.updateBreach()
        if self.isEditingSupervision {
            switch self.questionChanged {
            case .noChange:
                break
            case .changeToOk:
                NotificationCenter.default.post(name: .removeBreach, object: nil)
            case .changeToBreach:
                NotificationCenter.default.post(name: .addBreach, object: nil)
            }
        }
        self.questionChanged = .noChange
        NotificationCenter.default.post(name: .hideBreachReason, object: nil)
    }
}
