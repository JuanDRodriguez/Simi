//
//  TableViewCellUnit.swift
//  Supervisores
//
//  Created by Sharepoint on 7/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class TableViewCellUnit: UITableViewCell {
    static var reuseIdentifier: String = "\(String(describing: self))"
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCalle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func display(unit: UnitLite){
       lblTitle.text = "\(unit.key) \(unit.name)"
        lblCalle.text = "CALLE \(unit.street) #\(unit.number) COLONIA \(unit.colony) \(unit.state) CP \(unit.cp)"
    }
    
}
