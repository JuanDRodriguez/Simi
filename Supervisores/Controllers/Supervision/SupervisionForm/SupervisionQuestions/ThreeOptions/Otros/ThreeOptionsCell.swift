//
//  ThreeOptionsCell.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class ThreeOptionsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setInfo(selected: Bool){
        if selected {
            self.contentView.frame.size.height = 95
        } else {
            self.contentView.frame.size.height = 35
        }
    }
}
