//
//  QuestionFactory.swift
//  Supervisores
//
//  Created by Sharepoint on 11/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class QuestionFactory : NSObject{
    let frame : CGRect
    var yPosition : CGFloat  = 0
    let sizeNotSelected : CGFloat
    init(frame : CGRect, positionY : CGFloat, sizeNotSelected: CGFloat) {
        self.frame = frame
        self.sizeNotSelected = sizeNotSelected
        self.yPosition = positionY
        super.init()
    }
    
    func buildQuestion(question : [String: Any], isEditingSuperviion: Bool, delegate: ProtocolBreanch,vc: UIViewController) -> QuestionProtocol? {
        SupervisionListFormViewController.vc = vc
        guard let questionTypeInt = question[KeysQuestion.typeId.rawValue] as? Int else {return nil}
        guard let questionType = QuestionTypes(rawValue: questionTypeInt) else {return nil}

        let width = self.frame.size.width
        let frameQuestions = CGRect(x: 0, y: yPosition, width: width, height: (self.sizeNotSelected  - 10))
        switch questionType {
            case .binary:
                let binaryQuestion = BinaryQuestionView(selected: false, question: question, frame: frameQuestions, isEditingSupervision: isEditingSuperviion)
                binaryQuestion.setQuestionSize(size: self.sizeNotSelected)
                self.yPosition += self.sizeNotSelected
                binaryQuestion.delegate  = delegate
                binaryQuestion.vc = vc
                return binaryQuestion
            case .threeOptions:
                let threeQuestion = ThreeOptionsView(selected: false, question: question, frame: frameQuestions, isEditingSupervision: isEditingSuperviion)
                threeQuestion.setQuestionSize(size: self.sizeNotSelected)
                self.yPosition += self.sizeNotSelected
                threeQuestion.delegate = delegate
                threeQuestion.vc = vc
                return threeQuestion
            case .multipleChoice:
                let multipleChoice = MultipleChoiceView(selected: false, question: question, frame: frameQuestions, isEditingSupervision: isEditingSuperviion)
                multipleChoice.setQuestionSize(size: self.sizeNotSelected)
                self.yPosition += self.sizeNotSelected
                multipleChoice.vc = vc
                return multipleChoice
            case .emoji:
                let emojiQuestion = EmojiQuestionView(selected: false, question: question, frame: frameQuestions, isEditingSupervision: isEditingSuperviion)
                emojiQuestion.setQuestionSize(size: self.sizeNotSelected)
                self.yPosition += self.sizeNotSelected
                emojiQuestion.delegate = delegate
                emojiQuestion.vc = vc
                return emojiQuestion
            case .stars:
                let stars = StarsQuestionView(selected: false, question: question, frame: frameQuestions, isEditingSupervision: isEditingSuperviion)
                stars.setQuestionSize(size: self.sizeNotSelected)
                self.yPosition += self.sizeNotSelected
                stars.delegate = delegate
                stars.vc = vc
                return stars
        case .free:
            return nil
            break
        }
    }
}
