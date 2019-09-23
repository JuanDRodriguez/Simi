//
//  SupervisionList+NotificationFunctions.swift
//  Supervisores
//
//  Created by Sharepoint on 5/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension SupervisionListFormViewController {
    @objc func addBreach() {
        self.countNewBreaches += 1
        self.updateNewBreaches()
    }
    @objc func removeBreach() {
        if self.countNewBreaches > 0{
        self.countNewBreaches -= 1
        self.updateNewBreaches()
        }
    }
    func updateNewBreaches() {
        if self.isEditingSupervision && self.countNewBreaches > 0 {
            self.lblNumberChanges.isHidden = false
        } else  {
            self.lblNumberChanges.isHidden = true
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.lblNumberChanges.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion:{completion in
            UIView.animate(withDuration: 0.2, animations: {
                self.lblNumberChanges.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })}
        )
        self.lblNumberChanges.text = "\(self.countNewBreaches)"
        if self.countNewBreaches >= self.MAX_NEW_BREACHES {
            CurrentSupervision.shared.setEditingSupervisionLimit(isOnLimit: true)
            let alert = UIAlertController(title: "Nuevos incumplimientos", message: "Se han agregado \(self.countNewBreaches), no se podrán agregar mas, ¿Deseas iniciar una nueva supervisión?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Iniciar nueva", style: .default, handler: {
                action in
                self.createNewSupervision()
            }))
            alert.addAction(UIAlertAction(title: "Continuar", style: .cancel, handler: {
                action in
                self.continueWithSupervision()
            }))
            
            self.present(alert, animated: true)
        } else {
            CurrentSupervision.shared.setEditingSupervisionLimit(isOnLimit: false)
        }
    }
    
    @objc func showPauseReason() {
        if self.pauseReasons.count >  0 {
            guard let pickerView = self.pickerView else {
                return
            }
            self.view.addSubview(pickerView)
        } else {
            self.isShowingPause = true
            let _ = PauseReasonsViewModel.shared.getReasons(ovirrideCurrent: false)
        }
    }
    @objc func questionAnswered(notification: NSNotification) {
        guard let answered = notification.object as? Bool else { return }
        if self.currentQuestion < self.questions.count - 1 {
            if answered {
                self.questions[self.currentQuestion + 1].questionView.alpha = 1.0
            } else {
                self.questions[self.currentQuestion + 1].questionView.alpha = 0.5
            }
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        self.keyboardShowed = true
        //        if self.questions[self.currentQuestion].isInFullMode() {
        //            return
        //        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.questions[self.currentQuestion].showKeyBoard(sizeHeight: keyboardSize.height)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        //        if self.questions[self.currentQuestion].isInFullMode() {
        //            return
        //        }
        self.questions[self.currentQuestion].showKeyBoard(sizeHeight: -1.0)
    }
    @objc func keyboardDidHide(notification: NSNotification) {
        self.keyboardShowed = false
    }
    @objc func showBreachReason(){
        self.navBarC?.showBackButton(showed: false)
    }
    @objc func hideBreachReason(){
        self.navBarC?.showBackButton(showed: true)
    }
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    @objc func tryingAddBreaches() {
        let alert = UIAlertController(title: "Nuevos incumplimientos", message: "Ya no puedes agregar nuevos incumplimientos, ¿Deseas iniciar una nueva supervisión?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Iniciar nueva", style: .default, handler: {
            action in
            self.createNewSupervision()
        }))
        alert.addAction(UIAlertAction(title: "Continuar", style: .cancel, handler: {
            action in
            self.continueWithSupervision()
        }))
        self.present(alert, animated: true)
    }
}
