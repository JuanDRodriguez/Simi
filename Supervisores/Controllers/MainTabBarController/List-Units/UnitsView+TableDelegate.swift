//
//  UnitsView+Delegate.swift
//  Supervisores
//
//  Created by Sharepoint on 14/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension UnitsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.textSearching == ""{
            return 60.0
        }
        return 86.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = self.arrayHeaders[indexPath.section]
        guard let unit = self.unitsByState[sectionTitle]?[indexPath.row] else {return}
        let unitMenu = UnitDetail(unit: unit)
        self.present(unitMenu, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            let _ = MyUnitsViewModel.shared.getMyUnits(orderBy: self.currentOder)
            self.lottieView?.animationLoading()
        }
        
    }
}
