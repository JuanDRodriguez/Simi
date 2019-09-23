//
//  BreachReason+Protocol.swift
//  Supervisores
//
//  Created by Sharepoint on 13/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension BreachReasonView: BreachReasonProtocol, PickerDateViewDelegate, PickerSelectViewDelegate, ActionsVMProtocol, UIScrollViewDelegate {
    var breachReasonView: UIView! { get {return self} }
    func selectDate(date: Date) {
        self.datePickerView?.isHidden = true
        if var breachDate = self.breachDate {
            guard let breachId = breachDate[KeysBreachOption.id.rawValue] as? Int else { return }
            breachDate[KeysBreachOption.dateSolution.rawValue] = date
            self.breaches = self.breaches.map({breachMapped in
                guard let breachIdMapped = breachMapped[KeysBreachOption.id.rawValue] as? Int else { return breachMapped }
                if breachIdMapped == breachId {
                    return breachDate
                }
                return breachMapped
            })
            self.updateBreach(breach: breachDate)
            self.tableViewBreach.reloadData()
        } else {
            self.btnDateSolution.setTitle(Utils.stringFromDate(date: date), for: .normal)
            self.dateSolutionCommon = date
            self.btnAddAlert.isEnabled = true
        }
    }
    func getDateSolutionCommon() -> Date? {
        return self.dateSolutionCommon
    }
    func selectOption(_ option: Int, value: String) {
        self.optionsPickerView!.isHidden = true
        if var breachLevel = self.breachLevel {
            guard let breachId = breachLevel[KeysBreachOption.id.rawValue] as? Int else { return }
            let breachOption = self.arrayBreachOptions[option]            
            breachLevel[KeysBreachOption.levelBreach.rawValue] = value
            breachLevel[KeysBreachOption.levelBreachId.rawValue] = breachOption[KeysBreachLevel.id.rawValue] as? Int ?? -1
            self.breaches = self.breaches.map({breachMapped in
                guard let breachIdMapped = breachMapped[KeysBreachOption.id.rawValue] as? Int else { return breachMapped }
                if breachIdMapped == breachId {
                    return breachLevel
                }
                return breachMapped
            })
           self.updateBreach(breach: breachLevel)
            self.tableViewBreach.reloadData()
            return
        }
        self.btnActionSelection.setTitle(value, for: .normal)
        if self.actions.count > option {
            if let actionId = self.actions[option][KeysActions.id.rawValue] as? Int {
                self.btnActionSelection.tag = actionId
            }
        }
    }
    func cancelOption() {
        self.optionsPickerView!.isHidden = true
    }
    func showKeyBoard(sizeHeight : CGFloat){
        if sizeHeight > 0 {
            let newConst = sizeHeight - (self.btnSave.bounds.height + 10)
            self.bottomViewConstraint.constant = newConst
            if self.hasSuboptions {
                self.scrollContainer.contentSize = self.viewContetScroll.bounds.size
//                let countSubviews = self.scrollContainer.subviews.count
//                self.scrollContainer.contentSize = CGSize(width: 0, height: 49.0 * CGFloat(countSubviews - 1))
                for view in self.scrollContainer.subviews {
                    if let textView = view as? UITextField {
                        if textView.isEditing {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.scrollContainer.scrollToView(view: textView, animated: true)
                            }
                        }
                    }
                }
            } else {
                self.scrollContainer.contentSize = self.viewContetScroll.bounds.size
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let bottomOffset = CGPoint(x: 0, y: self.scrollContainer.contentSize.height - self.scrollContainer.bounds.size.height)
                    self.scrollContainer.setContentOffset(bottomOffset, animated: true)
                }
            }
        } else {
            self.bottomViewConstraint.constant = 0
        }
    }
    func getComment()->String {
        return self.txtCommentBreach.text ?? ""
    }
    func getAction()->(Int, String) {
        return (self.btnActionSelection.tag , self.btnActionSelection.currentTitle ?? "")
    }
    func getActionsError(error: Error) {
        
    }
    func getActions(actions: [[String : Any]]) {
        self.actions = actions
        if self.actions.count > 0 {
            self.btnActionSelection.isEnabled = true
            let action = self.actions[0]
            if let name = action[KeysActions.name.rawValue] as? String {
                self.btnActionSelection.setTitle(name, for: .normal)
            }
        } else {
            self.btnActionSelection.isEnabled = false
            self.btnActionSelection.setTitle("No hay acciones para mostrar", for: .normal)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: .hideKeyboard, object: nil)
    }
}
