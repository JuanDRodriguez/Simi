//
//  SupervisionReportViewController+Delegates.swift
//  Supervisores
//
//  Created by Sharepoint on 5/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension SupervisionReportViewController: PastSupervisionVMProtocol, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableBranch {
            print("Tamaño de items en Tabla: \(self.fsSupervisions.count + self.visitItems.count)")
            return self.fsSupervisions.count + self.visitItems.count
            
        }else{
        return self.franchiseSupervisions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.pastSupervisionCell.rawValue, for:indexPath) as? PastSupervisionTableViewCell
        if tableView == tableBranch {
            if self.fsSupervisions.count > indexPath.row{
                print("Index De supervisiones\(indexPath.row)")
                print("Data for Supervision\(self.fsSupervisions[indexPath.row])")
                cell!.setInfoSupervision(infoLabel: self.fsSupervisions[indexPath.row],
                                    showDetail: {[unowned self] supId in self.showDetailSupervision(supervisionId: supId)},
                                    showBreaches: {[unowned self] supId in self.showBreachesSupervision(supervisionId: supId)})
            }else{
                
                cell!.isVisit = true
                cell?.setVisit(visit:visitItems[indexPath.row - self.fsSupervisions.count],showDeatail: { [unowned self] visit in
                    let vc = VisitResumViewController()
                    vc.setData(visit: visit,idUnit: self.unit[KeysUnit.idUnit.rawValue] as! Int)
                    self.present(vc, animated: true, completion: nil)
                })
    
            }
            
        } else {
          
            cell!.setInfoSupervision(infoLabel: self.franchiseSupervisions[indexPath.row],
                                    showDetail: {[unowned self] supId in self.showDetailSupervision(supervisionId: supId)},
                                    showBreaches: {[unowned self] supId in self.showBreachesSupervision(supervisionId: supId)})
           
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func showDetailSupervision(supervisionId: Int) {
        print("MOSTRANDO DETALLEE")
        let supervisionDetail = SupervisionResumeViewController()
        supervisionDetail.supervisionId = supervisionId
        supervisionDetail.isDetail = true
        supervisionDetail.canEdit = true
        self.present(supervisionDetail, animated: true, completion: nil)
    }
    
    func showBreachesSupervision(supervisionId: Int){
        print("MOSTRANDO BREACHES")
        let supervisionDetail = SupervisionResumeViewController()
        supervisionDetail.supervisionId = supervisionId
        supervisionDetail.isDetail = true
        supervisionDetail.isOnlyBreaches = true
        supervisionDetail.canEdit = false
        self.present(supervisionDetail, animated: true, completion: nil)
    }

    func getPastSupervision(supervisors: [[String : Any]], franchise: [[String : Any]]) {
        self.fsSupervisions = supervisors
        self.franchiseSupervisions = franchise
        
        DispatchQueue.main.async {
            self.aux += 1
            if self.aux == 2{
                self.isReloaded = true
            self.tableBranch.reloadData()
            self.tableFranchise.reloadData()
            }
        }
    }
    
    func getPastSupervisionError() {
        print("ALGUN ERROR")
    }
}
