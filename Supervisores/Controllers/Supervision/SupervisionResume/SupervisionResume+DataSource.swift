//
//  SupervisionResume+DataSource.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension SupervisionResumeViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayHeaders.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.arrayHeaders[section] ==  "Atencion al cliente"{
            return  "Atención al cliente"
        }else{
        return self.arrayHeaders[section]
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = self.arrayHeaders[section]
        if let breaches = self.answerByModule[title] {
            return breaches.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var sectionTitle: String!
       
            sectionTitle = self.arrayHeaders[indexPath.section]
       
            let rowInSection = indexPath.row
        guard let answer = self.answerByModule[sectionTitle]?[rowInSection]
            else {
                return  ResumeSupervisionCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: Cells.unitCell.rawValue)
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.resumeCell.rawValue, for:indexPath) as? ResumeSupervisionCell else {
            let cellCreated = ResumeSupervisionCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: Cells.resumeCell.rawValue)
            cellCreated.setAnswer(answer: answer)
            return cellCreated
        }
        delagatefail = { return cell  as! ResumenSuperVisionDelegate}()
        delagatefail.openPopUp = {
           
        }
        cell.setAnswer(answer: answer)
        return cell
    }
}
