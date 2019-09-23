//
//  VisitMotivosCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class VisitMotivosCell: UITableViewCell {
    static var reuseIdentifier: String = "\(String(describing: self))"
    @IBOutlet weak var lblMotivo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func display(motivo: String, index: Int){
        self.lblMotivo.text = motivo
    }
    
}
