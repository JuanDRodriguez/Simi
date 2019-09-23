//
//  HeaderCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/22/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var lblheader: UILabel!
     static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func display(item:(String, UIColor)){
        lblheader.backgroundColor = item.1
        lblheader.text = item.0
    }
    
}
