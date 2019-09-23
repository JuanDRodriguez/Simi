//
//  MultipleChoice+TableView.swift
//  Supervisores
//
//  Created by Sharepoint on 12/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension MultipleChoiceView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idendifier = Cells.choiceCell.rawValue
        var option : [String: Any] = [:]
        if self.options.count > indexPath.row {
            option = options[indexPath.row]
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idendifier, for:indexPath) as? ChoiceCell else {
            let cellCreated = ChoiceCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: idendifier)
            cellCreated.setOption(option: option){[unowned self](option, status) in
                self.changeStatusOption(option: option, status: status)
            }
            cellCreated.index = indexPath.row
            return cellCreated
        }
        cell.setOption(option: option){[unowned self](option, status) in
            self.changeStatusOption(option: option, status: status)
        }
        cell.index = indexPath.row
        return cell
    }
    
    func checkOptions(questionId: Int){
        for option in self.options{
            if let idOpt = option[KeysOptionQuestion.id.rawValue] as? Int {
                if let seletecOpt = option[KeysOptionQuestion.selected.rawValue] as? Bool{
                    if seletecOpt{
                    QuestionViewModel.shared.optionSelected(idQuestion: questionId, idOption: idOpt, selected: seletecOpt)
                    }
                }
            }
        }
    }
    
    func changeStatusOption(option: [String: Any], status: Bool){
        guard let questionId = question[KeysQuestion.id.rawValue] as? Int else { return }
        guard let optionID = option[KeysOptionQuestion.id.rawValue] as? Int else { return }
        var chooseBreach = true
        if let weighing = option[KeysOptionQuestion.weighing.rawValue] as? Int {
            if weighing > 0 && status {//OPTION WITH WEIGHT TO CHOOSE
                chooseBreach = false
                self.questionAnswered = true
                NotificationCenter.default.post(name: .updateQuestionAswered, object: true)
                self.numberBreach = 0
                self.hideBreach()
                self.options = self.options.map({optionMaped in
                    if let id = optionMaped[KeysOptionQuestion.id.rawValue] as? Int {
                        var optionR = optionMaped
                        if id != optionID {
                            optionR[KeysOptionQuestion.selected.rawValue] = false
                        } else {
                            optionR[KeysOptionQuestion.selected.rawValue] = status
                        }
                        return optionR
                    }
                    return optionMaped
                })
                self.checkOptions(questionId: questionId)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.tableOptions.reloadData()
                })
            }
        }
        var hasToReload = false
        if chooseBreach {
            
            
            if self.isEditingSupervision && CurrentSupervision.shared.isEditingOnLimit() {
                NotificationCenter.default.post(name: .tryingAddBreaches, object: nil)
                return
            }
            
            
            self.options = self.options.map({[unowned self] optionMaped in
                if let id = optionMaped[KeysOptionQuestion.id.rawValue] as? Int {
                    var optionR = optionMaped
                    if id == optionID {
                        optionR[KeysOptionQuestion.selected.rawValue] = status
                        self.checkBreaches(option: optionR, checked: status, substactValid: true)
                        return optionR
                    }
                    if let weighing = optionMaped[KeysOptionQuestion.weighing.rawValue] as? Int {
                        if weighing > 0 {
                            optionR[KeysOptionQuestion.selected.rawValue] = false
                            hasToReload = true
                            return optionR
                        }
                    }
                }
                return optionMaped
            })
            self.checkOptions(questionId: questionId)
        }
        if hasToReload {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.tableOptions.reloadData()
            })
        }
        self.questionAnswered = false
        for optionSelected in self.options {
            if let selected = optionSelected[KeysOptionQuestion.selected.rawValue] as? Bool {
                if selected {
                    self.questionAnswered = true
                    NotificationCenter.default.post(name: .updateQuestionAswered, object: true)
                    return
                }
            }
        }
        NotificationCenter.default.post(name: .updateQuestionAswered, object: false)
        self.updateQuestion()
        self.questionLoaded = true
    }
    
    func checkBreaches(option: [String: Any], checked: Bool, substactValid: Bool){
        guard let breach = option[KeysOptionQuestion.breach.rawValue] as? Bool else { return }
        if breach {
            self.numberBreach += (checked ? 1 : (substactValid ? -1 : 0))
        }
        if self.numberBreach > 0 {
            if self.viewBreachReason.isHidden {
                self.showBreach()
            }
            if self.questionLoaded {
                self.questionChanged = .changeToBreach
            }
            if isEditingSupervision {
                self.tableOptions.allowsSelection = false
            }
        } else {
            if self.questionLoaded {
                self.questionChanged = .changeToOk
            }
            if !self.viewBreachReason.isHidden {
                self.hideBreach()
            }
        }
    }
}
