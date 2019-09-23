//
//  SupervisionReportViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 30/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class SupervisionReportViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var tableBranch: UITableView!
    @IBOutlet weak var tableFranchise: UITableView!
    @IBOutlet weak var viewFranchise: UIView!
    
    var unit: [String: Any]
    var fsSupervisions : [[String: Any]] = []
    var franchiseSupervisions : [[String: Any]] = []
    var visitItems: [VisistItem] = []
    var isReloaded = false
    var index = 0
    var aux = 0
     let model = VisitModel()
    let modelIncum = IncumplimientoModel()
    init(unit: [String: Any]){
        self.unit = unit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.unit = [:]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.currentProfile != .franchisee{
            viewFranchise.isHidden = true
        }
        var nameUnit = ""
        if let name = self.unit[KeysUnit.name.rawValue] as? String,let key = self.unit[KeysUnit.key.rawValue] as? String {
            nameUnit = "\(key) \(name)"
        }
        CommonInit.navBArIndicators(vc: self, navigationBar: self.navBar, title: nameUnit)
        PastSupervisionViewModel.shared.setListener(listener: self)
        let nib = UINib(nibName: "PastSupervisionTableViewCell", bundle: nil)
        self.tableBranch.register(PastSupervisionTableViewCell.self, forCellReuseIdentifier: Cells.pastSupervisionCell.rawValue)
        self.tableBranch.register(nib, forCellReuseIdentifier: Cells.pastSupervisionCell.rawValue)
        self.tableFranchise.register(PastSupervisionTableViewCell.self, forCellReuseIdentifier: Cells.pastSupervisionCell.rawValue)
        self.tableFranchise.register(nib, forCellReuseIdentifier: Cells.pastSupervisionCell.rawValue)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let idUnit = self.unit[KeysUnit.idUnit.rawValue] as? Int {
            model.output = self
            model.idUnit = idUnit
            model.loadVisited(idUnit: idUnit)
            PastSupervisionViewModel.shared.getSupervisionByUnit(unitId: idUnit)
        }
        
        aux = 0
    }
}
extension SupervisionReportViewController: visitedModelOutput, IncumplimientoModelOutput{
    func modelDidLoad(_ items: [Incumplimientositem]) {
        
    }
    
    func modelDidLoad(_ Items: [VisistItem]) {
        self.visitItems = Items

        
        DispatchQueue.main.async {
            self.aux += 1
            if self.aux == 2{
                self.isReloaded = true
                self.tableBranch.reloadData()
                self.tableFranchise.reloadData()
            }
        }
    }
}
