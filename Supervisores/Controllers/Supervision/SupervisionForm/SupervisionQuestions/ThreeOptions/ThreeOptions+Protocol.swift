//
//  ThreeOptions+Protocol.swift
//  Supervisores
//
//  Created by Sharepoint on 12/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension ThreeOptionsView: QuestionProtocol {
    var questionView: UIView! {
        get {return self}
    }
    func setQuestionSize(size: CGFloat){
        self.questionSize = size
    }
    func setQuestionActive(active: Bool, posY: CGFloat, speedAnimation: Double) {
        let speed : TimeInterval = TimeInterval(speedAnimation)
        self.isSelectedCell = active
        if let superView = self.superview {
            if active {
                self.txtComment.isHidden = false
                UIView.animate(withDuration: speed, animations: {[unowned self] in
                    self.frame.origin.y = posY
                    self.frame.size.height = superView.bounds.size.height - self.questionSize * 2
                    self.adjustTitleMax()
                })
            } else {
                self.txtComment.isHidden = true
                UIView.animate(withDuration: speed, animations: {[unowned self] in
                    self.frame.origin.y = posY
                    self.frame.size.height = self.questionSize - 10.0
                    self.adjustTitleMin()
                })
            }
        }
        if active {
            self.questionChanged = .noChange
            print("RESET CAMBIOS!!!! T \(question[KeysQuestion.topic.rawValue])")
        } else  {
          
        }
    }
        
    func isInFullMode()->Bool {
        return self.isFullMode
    }
    
    func openBreachReasons() {
        guard let parentView = self.superview else { return }
        self.isFullMode = true
        parentView.bringSubviewToFront(self)
        let bottom = self.lblLegend.frame.maxY
        if self.breachReason == nil {
            let rectBRView = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: parentView.bounds.height - bottom)
            self.breachReason = self.breachReasonFactory.buildReachReasonView(question: self.question, option: self.optionBreach , frameView: rectBRView)
            self.addSubview(self.breachReason!.breachReasonView)
            self.breachReason?.delegate = self
        }
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.frame = CGRect(x: 0, y: 0, width: parentView.bounds.width, height: parentView.bounds.height)
            self.breachReason!.breachReasonView.frame.origin.y = bottom
        })
        NotificationCenter.default.post(name: .showBreachReason, object: nil)
    }
    
    func hasBreachPendient()->Bool {
        return !self.viewBreachReason.isHidden && !self.reachedReasonsComplete
    }
}
