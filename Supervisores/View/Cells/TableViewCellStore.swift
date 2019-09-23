//
//  TableViewCellStore.swift
//  Supervisores
//
//  Created by Sharepoint on 7/5/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class TableViewCellStore: UITableViewCell {
    static var reuseIdentifier: String = "\(String(describing: self))"
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var units: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    func display(item: [String]){
       img.image = UIImage(named: "\(item[0])")
        name.text = "\(item[1])"
        units.text = "\(item[2])"
        units.textColor = UIColor.init(hexString: item[3], alpha: 1.0)
        
    }
    
}
