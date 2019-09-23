//
//  SupervisionList+VMDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 15/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
extension SupervisionListFormViewController : QuestionVMProtocol, PickerSelectViewDelegate, PauseReasonsVMProtocol {
    func questionUpdated(question: [[String : Any]]) {
        if question.count > 0 {
            if self.isEditingSupervision {
                self.questionsDicto = question.filter({
                    guard let answered = $0[KeysQuestion.answered.rawValue] as? Bool else { return false }
                    return answered
                })
            } else {
                self.questionsDicto = question
            }
            DispatchQueue.main.async {
                self.loadQuestions()
                if self.currentQuestion == self.questions.count - 1 {
                    let heigth = self.questionsView.frame.height
                    let yPos = heigth - self.spaceQuestion
                    UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                        self.footerQuestion?.frame.origin.y = yPos
                    })
                }
            }
        }
    }
    func finishWithError(error: Error) {
        
        self.dismiss(animated: true, completion: {
            self.lottieView?.animationFinishError()
            })
    }
    func finishLoadQuestion() {
        self.lottieView?.animationFinishCorrect()
    }
    func selectOption(_ option: Int, value: String) {
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
        let pauseOpt = self.pauseReasons[option]
        guard let idPause = pauseOpt[KeysPause.id.rawValue] as? Int else {return}
        guard let descPause = pauseOpt[KeysPause.reason.rawValue] as? String else {return}
        Storage.shared.saveNewPause(idReason: idPause, descReason: descPause)
       // let savePauseRemotly: SavePauseRemotly = SavePause.shared
        //savePauseRemotly.savePauseInServer()
        self.delegate?.dissmisVC()
        self.dismiss(animated: true, completion: nil)
    }
    func cancelOption() {
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
    }
    func reasonsUpdated(reasons: [[String : Any]]) {
        self.pauseReasons = reasons
        let str: [String] = reasons.map({
            return $0[KeysPause.reason.rawValue] as! String
        })
        self.pickerView!.updateOptions(options: str)
        if self.isShowingPause {
            self.isShowingPause = false
            DispatchQueue.main.async {
                guard let pickerView = self.pickerView else { return }
                self.view.addSubview(pickerView)
            }
        }
    }
    func finishWithErrorReasons(error: Error) {
        
    }
    func finishLoadReasons() {
        
    }
}
