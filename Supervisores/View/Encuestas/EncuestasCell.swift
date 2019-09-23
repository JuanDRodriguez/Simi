//
//  EncuestasCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/29/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class EncuestasCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblEncuesta: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblVontador: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func display(_ item: EncuestasItem, count: Int){
        lblEncuesta.text = item.Nombre
        lblFecha.text = Utils.stringRemainingDays(now: Date(), end: Utils.dateFromService(stringDate: item.FechaTermino!))
        lblVontador.text = "\(count)"
       
    }

}
