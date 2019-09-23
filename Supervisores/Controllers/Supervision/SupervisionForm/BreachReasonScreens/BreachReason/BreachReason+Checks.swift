//
//  BreachReason+Checks.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/20/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension BreachReasonView {
    func checkComment() {
        self.txtCommentBreach.addBorder()
        guard let comment = question[KeysQuestion.comment.rawValue] as? Bool else {
            self.txtCommentBreach.isHidden = true
            self.bottomCommentConstraint.constant = 0
            self.heightCommentConstraint.constant = 0
            return
        }
        if !comment {
            self.txtCommentBreach.isHidden = true
            self.bottomCommentConstraint.constant = 0
            self.heightCommentConstraint.constant = 0
            return
        } else {
            guard let forcedComment = question[KeysQuestion.commentForced.rawValue] as? Bool else {
                return
            }
            if forcedComment {
                self.commentforced = true
                self.txtCommentBreach.placeholder = "Escribe un comentario (Obligatorio)"
            } else {
                self.txtCommentBreach.placeholder = "Escribe un comentario"
            }
            
            if let hasBreach = self.question[KeysQuestion.hasBreach.rawValue] as? Bool {
                if hasBreach {
                    if let comment = self.question[KeysQuestion.commentDescripton.rawValue] as? String{
                        self.txtCommentBreach.text = comment
                        self.txtCommentBreach.textViewDidChange(self.txtCommentBreach)
                    }
                }
            }
        }
        self.scrollSize += self.txtCommentBreach.bounds.height + 5.0
    }
    func checkPhoto() {
        guard let photo = question[KeysQuestion.photo.rawValue] as? Bool else {
            self.viewPhotos.isHidden = true
            self.bottomPhotoConstraint.constant = 0
            self.heightPhotoConstraint.constant = 0
            return
        }
        if !photo {
            self.viewPhotos.isHidden = true
            self.heightPhotoConstraint.constant = 0
            self.bottomPhotoConstraint.constant = 0
            return
        }
        self.scrollSize += self.viewPhotos.bounds.height + 5.0
        guard let forcedPhoto = question[KeysQuestion.photoForced.rawValue] as? Bool else {
            return
        }
        if forcedPhoto {
            self.photoForced = true
        }
    }
    func checkDatePicker () {
        if self.datePickerView == nil {
            self.datePickerView = PickerDateView(frame: self.bounds)
            self.datePickerView?.setTitle(title: "Escoge una fecha de solución")
            self.datePickerView?.delegate = self
            self.addSubview(self.datePickerView!)
        }
        self.datePickerView!.isHidden = false
        self.bringSubviewToFront(self.datePickerView!)
    }
    func checkActions(){
        self.stackActionView.isHidden = true
        self.heightActionConstraint.constant = 0
        self.bottomActionConstraint.constant = 0
        guard let action = question[KeysQuestion.action.rawValue] as? Bool else { return }
        if action {
            self.stackActionView.isHidden = false
            self.heightActionConstraint.constant = 60
            self.bottomActionConstraint.constant = 5
            self.scrollSize += 65.0
            
            if let saveAction = self.question[KeysQuestion.actionDescription.rawValue] as? String {
                self.btnActionSelection.setTitle(saveAction, for: .normal)
            }
            if let saveActionId = self.question[KeysQuestion.actionId.rawValue] as? Int {
                self.btnActionSelection.tag = saveActionId
            }
        }
    }
    func checkOptionsPicker (options: [String]) {
        if self.optionsPickerView == nil {
            self.optionsPickerView = PickerSelectView(dataPicker: options, frame: self.bounds)
            self.optionsPickerView?.delegate = self
            self.addSubview(self.optionsPickerView!)
        } else {
             self.optionsPickerView?.updateOptions(options: options)
        }
        self.optionsPickerView!.isHidden = false
        self.bringSubviewToFront(self.optionsPickerView!)
    }
    func checkDate() {
        if let dateSolution = self.question[KeysQuestion.dateSolution.rawValue] as? Bool{
           if self.hasBreachLevel{
            self.viewDateBreach.isHidden = true
            self.bottomDateConstraint.constant = 0
            self.heightDateConstraint.constant = 0
            return
           }else{
            self.generalDate = true
            if let saveDate = self.question[KeysQuestion.dateCommonSolution.rawValue] as? Date {
                self.dateSolutionCommon = saveDate
                self.btnDateSolution.setTitle(Utils.stringFromDate(date: saveDate), for: .normal)
            }
            
            }
        }
        self.scrollSize += self.viewDateBreach.bounds.height + 5.0
    }
    func checkBreachs(height: Int, width: Int) {//ADD BREACHES TO VIEW
        if let suboption = self.option[KeysOptionQuestion.subOption.rawValue] as? Bool{
            if suboption {
                self.checkSuboptions(height: height, width: width)
                return
            }
        }
        if let arrsub =  self.option[KeysOptionQuestion.arraySubOptions.rawValue] as? [[String:Any]] {
            if arrsub.count > 0{
                self.checkSuboptions(height: height, width: width)
                return
            }
        }
        self.viewTableBreach.frame = CGRect(x: 0, y: 0, width: width, height: Int(self.viewBreaches.bounds.height))
        self.viewBreaches.addSubview(self.viewTableBreach)

        if self.breaches.count == 0 {
            self.heightBreachConstraint.constant = 0
            self.bottomListConstraint.constant = 0
            self.viewBreaches.isHidden = true
            return
        }
        let maxSize = Int(Double(height) * 0.75)
        if self.cellSize * self.breaches.count >  maxSize{
            self.scrollSize += CGFloat(maxSize) + 5.0
        } else {
            self.scrollSize += CGFloat(self.cellSize * self.breaches.count)
        }
    }

    func checkBreaches() {//ADD BREACHES TO ARRAY
        if let breaches = self.option[KeysOptionQuestion.breaches.rawValue] as? [[String: Any]] {
            for var breach in breaches {
                if let _ = breach[KeysBreachOption.isSelected.rawValue] as? Bool{
                } else {
                    breach[KeysBreachOption.isSelected.rawValue] = false
                }
                if let dateB =  breach[KeysBreachOption.dateSolution.rawValue] as? Date {
                    self.selectDate(date: dateB)
                } else {
                    breach[KeysBreachOption.dateSolution.rawValue] = "dd-mm-aaaa"
                }
                if let _ = breach[KeysBreachOption.levelBreach.rawValue] as? String {
                } else {
                    breach[KeysBreachOption.levelBreach.rawValue] = TypeBreach.critic.rawValue
                }
                self.breaches.append(breach)
            }
        }
    }
}
