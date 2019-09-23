//
//  QuestionProtocol.swift
//  Supervisores
//
//  Created by Sharepoint on 11/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

enum QuestionChanged {
    case noChange
    case changeToBreach
    case changeToOk
}

protocol QuestionProtocol {
    var questionView : UIView! { get }
    var nibView : UIView! { get }
    var lblTitle: UILabel! { get }
    var lblTopic: UILabel! { get }
    var lblLegend: UILabel! { get }
    var hiddenViews : [UIView]! { get set }
    var txtComment: UITextView! { get }
    var viewBreachReason: UIView! {get set}
    var questionSize: CGFloat { get }
    var isSelectedCell : Bool {get}
    var isEditingSupervision : Bool {get set}
    var questionAnswered : Bool {get set}
    var breachReason : BreachReasonProtocol? {get set}
    var bottomTxtComment: NSLayoutConstraint! {get}
    var bottomLegendConstraint: NSLayoutConstraint! {get}
    var question : [String: Any] {get set}
    var questionChanged : QuestionChanged {get set}
    var optionBreach : [String: Any]? {get set}
    var heightCommentConstraint: NSLayoutConstraint! {get set}
    var hasBreach: Bool {get set}
    var reachedReasonsComplete: Bool {get set}
    func hasBreachPendient()->Bool
    func isInFullMode()->Bool
    func openBreachReasons()
    func setQuestionSize(size: CGFloat)
    func setQuestionActive(active: Bool, posY: CGFloat, speedAnimation: Double)
    func checkComment()
    func checkTitles()
    func checkSendEmail()
    func adjustTitleMin()
    func adjustTitleMax()
    func hiddeComments()
    func showComments()
    func getQuestionResponse()->(id : Int, actionId: Int, action :String,comment : String,hasBreach :Bool, dateSolutionCommon: Date?)
    mutating func showKeyBoard(sizeHeight : CGFloat)
    func updateOptionSelected(selected: Bool, idOption: Int)
}
extension QuestionProtocol {
    func checkTitles() {
        self.lblTitle.text = question[KeysQuestion.question.rawValue] as? String ?? ""
        self.lblTopic.text = question[KeysQuestion.topic.rawValue] as? String ?? ""
        self.lblLegend.text = question[KeysQuestion.legend.rawValue] as? String ?? ""
        self.lblTitle.text = self.lblTitle.text?.trim()
        self.lblTopic.text = self.lblTopic.text?.trim()
        self.lblLegend.text = self.lblLegend.text?.trim()
        if self.lblLegend.text == "" {
            self.bottomLegendConstraint.constant = 0
        }
    }
    func updateOptionSelected(selected: Bool, idOption: Int) {
        guard let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int else { return }
        QuestionViewModel.shared.optionSelected(idQuestion: idQuestion, idOption: idOption, selected: selected)
    }
    func checkComment() {
        self.txtComment.addBorder()
        self.txtComment.placeholder = "Escribe un comentario"
        
        if let hasBreach = self.question[KeysQuestion.hasBreach.rawValue] as? Bool {
            if !hasBreach {
                if let comment = self.question[KeysQuestion.commentDescripton.rawValue] as? String{
                    self.txtComment.text = comment
                    self.txtComment.textViewDidChange(self.txtComment)
                }
            }
        }
    }
    func adjustTitleMin() {
        self.lblTopic.font = self.lblTopic.font.withSize(12)
        self.lblTitle.font = self.lblTitle.font.withSize(10)
        self.lblTopic.backgroundColor = .clear
        self.lblTitle.backgroundColor = .clear
        self.lblTitle.numberOfLines = 1
        self.lblTitle.adjustsFontSizeToFitWidth = true
        self.lblTitle.minimumScaleFactor = 0.4
        self.viewBreachReason.isHidden = true
    }
    func adjustTitleMax(){
        self.lblTopic.font = self.lblTopic.font.withSize(20)
        self.lblTitle.font = self.lblTitle.font.withSize(15)
        self.lblTitle.numberOfLines = 0
        self.lblTitle.adjustsFontSizeToFitWidth = false
        self.lblTitle.minimumScaleFactor = 1.0
        if self.hasBreach {
            self.viewBreachReason.isHidden = false
        }
    }
    func hiddeComments(){
        self.txtComment.isHidden = true
        self.heightCommentConstraint.constant = 0
    }
    func showComments(){
        self.txtComment.isHidden = false
        self.heightCommentConstraint.constant = 110
    }
    func getQuestionResponse()->(id : Int, actionId: Int, action :String, comment : String, hasBreach :Bool,  dateSolutionCommon: Date?) {
        let id = self.question[KeysQuestion.id.rawValue] as? Int
        var actionSnd = ""
        var actionIdSnd = -1
        var comment = self.txtComment.text
        if self.hasBreach {
            let (actionId, action) = breachReason?.getAction() ?? (-1, "")
            comment = breachReason?.getComment()
            actionSnd = action
            actionIdSnd = actionId
        }
        let dateSolutionCommon = breachReason?.getDateSolutionCommon()
        return (id ?? 0, actionIdSnd, actionSnd, comment ?? "", self.hasBreach, dateSolutionCommon)
    }
    mutating func showKeyBoard(sizeHeight : CGFloat) {
        if self.isInFullMode() {
            if self.breachReason != nil {
                self.breachReason?.showKeyBoard(sizeHeight: sizeHeight)
            }
            return
        }
        if self.isSelectedCell {
            if sizeHeight > 0 {
                guard let totalHeight = questionView.superview?.superview?.frame.height else { return }
                guard let posY = questionView.superview?.frame.origin.y else { return }
                let upKeyboard = totalHeight - sizeHeight
                let positionInit = posY + self.questionSize
                let newSize = upKeyboard - positionInit
                questionView.frame.size.height = newSize
            
                let originComment = newSize - (self.txtComment.bounds.height + 10)
               self.hiddenViews!.removeAll()
                for subView in self.nibView.subviews {
                    let endView = subView.frame.origin.y + subView.bounds.height
                    if subView != self.txtComment && !subView.isHidden && endView > originComment {
                        hiddenViews.append(subView)
                        subView.isHidden = true
                    }
                }
            } else {
                for view in self.hiddenViews {
                    view.isHidden = false
                }
                self.hiddenViews.removeAll()
                guard let parentHeight = questionView.superview?.frame.height else { return }
                self.questionView.frame.size.height =  parentHeight - self.questionSize * 2
            }
        }
    }
    func checkSendEmail() {
        guard let options = self.question[KeysQuestion.options.rawValue] as? [[String: Any]] else {return}
        for option in options {
            guard let optionId = option[KeysOptionQuestion.id.rawValue] as? Int else { continue }
            guard let selected = option[KeysOptionQuestion.selected.rawValue] as? Bool else { continue }
            guard let sendMail = option[KeysOptionQuestion.mail.rawValue] as? Bool else { continue }
            guard let suboptions = option[KeysOptionQuestion.arraySubOptions.rawValue] as? [[String: Any]] else { continue }
            if selected && sendMail {
                QuestionViewModel.shared.sendMailSuboption(arraySuboptions: suboptions, optionId: optionId)
            }
        }
    }
}
