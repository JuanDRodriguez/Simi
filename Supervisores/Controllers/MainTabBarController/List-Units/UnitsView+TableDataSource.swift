//
//  UnitsView+DataSource.swift
//  Supervisores
//
//  Created by Sharepoint on 14/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension UnitsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayHeaders.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.arrayHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = self.arrayHeaders[indexPath.section]
        let rowInSection = indexPath.row
        guard let unit = self.unitsByState[sectionTitle]?[rowInSection]
        else {
            return  UnitCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: Cells.unitCell.rawValue)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.unitCell.rawValue, for:indexPath) as? UnitCell else {
            let cellCreated = UnitCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: Cells.unitCell.rawValue)
            cellCreated.lblUnit.text = unit[KeysUnit.name.rawValue] as? String
            return cellCreated
        }
        cell.setInfoCell(unit: unit, orderBy: self.currentOder, currentPosition: self.currentLocation, textSearched: self.textSearching)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = self.arrayHeaders[section]
        if let units = self.unitsByState[title] {
            return units.count
        }
        return 0
    }
}
