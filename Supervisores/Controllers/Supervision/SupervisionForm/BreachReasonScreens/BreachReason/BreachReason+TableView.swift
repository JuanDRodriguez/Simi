//
//  BreachReason+TableView.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension BreachReasonView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.breaches.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(self.cellSize)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idendifier = Cells.breachCell.rawValue
        var breach : [String: Any] = [:]
        if self.breaches.count > indexPath.row {
            breach = self.breaches[indexPath.row]
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idendifier, for:indexPath) as? BreachCell else {
            let cellCreated = BreachCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: idendifier)
            cellCreated.setBreach(dateSolution: self.solutionDate, breachLevel: self.hasBreachLevel, breach: breach, question: self.question) {
                [unowned self] breachUpdated  in
                self.updateBreach(breach: breachUpdated)
            }
            return cellCreated
        }
        cell.setBreach(dateSolution: self.solutionDate, breachLevel: self.hasBreachLevel, breach: breach, question: self.question) {
            [unowned self] breachUpdated  in
            self.updateBreach(breach: breachUpdated)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var breach : [String: Any] = [:]
        if self.breaches.count > indexPath.row {
            breach = self.breaches[indexPath.row]
        }
        guard let selected = breach[KeysBreachOption.isSelected.rawValue] as? Bool else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? BreachCell else { return }
        breach[KeysBreachOption.isSelected.rawValue] = !selected
        if selected{
            breach[KeysBreachOption.levelBreach.rawValue] = ""
            breach[KeysBreachOption.levelBreachId.rawValue] = -1
        }
        cell.setBreach(dateSolution: self.solutionDate, breachLevel: self.hasBreachLevel, breach: breach, question: self.question){
            [unowned self] breachUpdated  in
            self.updateBreach(breach: breachUpdated)
            
        }
         self.updateBreach(breach: breach)
        if selected == false && self.hasBreachLevel{
           
            NotificationCenter.default.post(name: .showLevelBreach, object: breach)
        }
        
    }
    func updateBreach(breach: [String: Any]){
        self.breaches = self.breaches.map({ breachMap in
            guard let idMapped = breachMap[KeysBreachOption.id.rawValue] as? Int else { return breachMap }
            guard let idChanged = breach[KeysBreachOption.id.rawValue] as? Int else { return breachMap }
            if idMapped == idChanged {
                return breach
            }
            return breachMap
        })
        guard let optionId = self.option[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard let questionId = self.question[KeysQuestion.id.rawValue] as? Int else {return}
        QuestionViewModel.shared.updateBreach(breach: breach, idOption: optionId, idQuestion: questionId)
    }
}
