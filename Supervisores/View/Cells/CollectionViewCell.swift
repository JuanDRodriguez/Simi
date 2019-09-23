//
//  UICollectionViewCell.swift
//  Supervisores
//
//  Created by Sharepoint on 7/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String = "\(String(describing: self))"
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.layer.cornerRadius = CGFloat(17.0)
        lblTitle.clipsToBounds = true
        lblTitle.layer.borderWidth = 1
        
        
    }
    func setColorBlue()  {
        lblTitle.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.5764705882, blue: 0.9764705882, alpha: 1)
        lblTitle.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lblTitle.layer.borderColor = #colorLiteral(red: 0.01568627451, green: 0.4862745098, blue: 0.862745098, alpha: 1).cgColor
    }
    func returnColor(){
        lblTitle.backgroundColor = UIColor.white
        lblTitle.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblTitle.layer.borderColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1).cgColor
    }
    

}
