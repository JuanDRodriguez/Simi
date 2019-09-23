//
//  MessageCell.swift
//  Supervisores
//
//  Created by Sharepoint on 9/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    @IBOutlet weak var lblAsunto: UILabel!
    @IBOutlet weak var lblMensaje: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func display(_ item: [String]){
        if item.count > 0{
            lblAsunto.text = "Asunto: \(item[0])"
            lblMensaje.text = item[1]
        }
    }
    
}
