//
//  CollectionViewCellUnit.swift
//  Supervisores
//
//  Created by Sharepoint on 7/17/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class CollectionViewCellUnit: UICollectionViewCell {
    static var reuseIdentifier: String = "\(String(describing: self))"

    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblUnitTitle: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var stackServicesUnit: UIStackView!
    @IBOutlet weak var lblEtiqueta: UILabel!
    var unitInfo: UnitInfo!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(10.0)
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    func setUnit(unit: Unit){
        for view in self.stackServicesUnit.subviews {
            if let imgService = view as? UIImageView {
                imgService.isHidden = true
            }
        }
        
        self.unitInfo = UnitInfoViewModel.shared.unitInfo
        
        self.isHidden = false
        let key = unit.key
        let name = unit.name
            self.lblUnitTitle.text = "\(key) \(name)"
        
       let contact = unit.contact
        
        
       // print("Tipo de unidad: \(TypeUnit.typeUnit )")
        if TypeUnit.typeUnit == 1{
            self.lblEtiqueta.text = "Gerente:"
            self.lblContact.text = self.unitInfo.gerente!
        }else{
            self.lblEtiqueta.text = "Contacto:"
             self.lblContact.text = contact
        }
        if unit.services!.count > 0{
            for service in unit.services! {
                self.stackServicesUnit.viewWithTag(service.id)?.isHidden = false
            }
        }
        if unit.status == 4 || unit.status == 3{
            lblPercent.text = "\(0)%"
            lblPercent.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }else{
        guard let value = self.unitInfo.indicator?.value else {
            return
        }
        guard let idumbral = self.unitInfo.indicator?.id else{
            return
        }
        lblPercent.text = "\(Int(value))%"
        lblPercent.backgroundColor = UIColor.init(hexString:Operation.getUmbral(id: idumbral, value: Double(value)), alpha: 1.0)
        }
    }
}
