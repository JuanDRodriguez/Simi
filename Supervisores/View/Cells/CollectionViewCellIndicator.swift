//
//  CollectionViewCellIndicator.swift
//  Supervisores
//
//  Created by Sharepoint on 7/5/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class CollectionViewCellIndicator: UICollectionViewCell {
    static var reuseIdentifier: String = "\(String(describing: self))"
     @IBOutlet weak var lblIndicatorCrease: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
     @IBOutlet weak var lblSucursal: UILabel!
     @IBOutlet weak var lblFranquicia: UILabel!
     @IBOutlet weak var lblLaboratorio: UILabel!
    @IBOutlet weak var imgTotal: UIImageView!
    @IBOutlet weak var imgSucursal: UIImageView!
    @IBOutlet weak var imgFranquicia: UIImageView!
    @IBOutlet weak var imgLaboratorio: UIImageView!
     @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(10.0)
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        
        self.lblIndicatorCrease.layer.masksToBounds = true
        self.lblIndicatorCrease.layer.cornerRadius = CGFloat(8.0)
        self.lblIndicatorCrease.clipsToBounds = true
    }
    func display(_ items: ContactoItem){
        self.lblTitle.text = items.Nombre
        if let indicator = items.Indicador16Dto{
       self.lblIndicatorCrease.text = "\(Int((indicator.Valor)))%"
            let s = isEnable(value: 0)
            lblSucursal.textColor = s.2
            imgSucursal.alpha = s.1
            lblLaboratorio.text = "\(0)"
            let l = isEnable(value: 0)
            lblSucursal.text = "\(0)"
            lblLaboratorio.textColor = l.2
            imgLaboratorio.alpha = l.1
            lblFranquicia.text = "\(items.Unidades)"
            let f = isEnable(value: 1)
            lblFranquicia.textColor = f.2
            imgFranquicia.alpha = f.1
            lblTotal.text = "\(items.Unidades)"
        }
    }
    func display(_ item: IndicatorResumItem){
        //self.lblIndicatorCrease.isHidden = true
        self.lblTitle.text = item.Nombre
        lblTotal.text = "\(item.Total!)"
        let t = isEnable(value: (item.Total!))
        lblTotal.textColor = t.2
         imgTotal.alpha = t.1
        
        lblSucursal.text = "\(item.Sucursales!)"
        let s = isEnable(value: item.Sucursales!)
        lblSucursal.textColor = s.2
        imgSucursal.alpha = s.1
        lblFranquicia.text = "\(item.Franquicias!)"
        let f = isEnable(value: item.Franquicias!)
        lblFranquicia.textColor = f.2
        imgFranquicia.alpha = f.1
        lblLaboratorio.text = "\(item.Laboratorios!)"
        let l = isEnable(value: (item.Laboratorios!))
        
        lblLaboratorio.textColor = l.2
        imgLaboratorio.alpha = l.1
         self.lblIndicatorCrease.text = "\(Int((item.Indicador16?.Valor!)!))%"
        if item.Indicador16?.Umbral != nil {
            self.lblIndicatorCrease.isHidden = false
        self.lblIndicatorCrease.backgroundColor = UIColor.init(hexString: (item.Indicador16?.Umbral!)!, alpha: 1.0)
       
        }else{
            self.lblIndicatorCrease.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
    }
    func isEnable(value: Int) -> (Bool,CGFloat,UIColor){
        if value == 0{
            return (false,0.5,#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        }else{
            return (true, 1.0,#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
}
