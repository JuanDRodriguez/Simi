//
//  TableViewCellIndicator.swift
//  Supervisores
//
//  Created by Sharepoint on 7/4/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class TableViewCellIndicator: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblCircule: UILabel!
    static var reuseIdentifier: String = "\(String(describing: self))"
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func display(indicator: IndicatorItem, style: CatalogIndicatorItem, index: Int){
        lblTitle.text = ""
        lblValue.text = ""
        lblCircule.text = ""
         
        if style.Umbrales!.count > 0{
            //lblCircule.isHidden = style.Umbrales![0].Activo!
            lblCircule.layer.cornerRadius = CGFloat(8.0)
            lblCircule.layer.masksToBounds = true
            lblCircule.clipsToBounds = true
            lblCircule.isHidden = false
            self.lblCircule.backgroundColor = UIColor.init(hexString: style.Umbrales![0].Color!)
            
        }else{
            
        self.lblCircule.isHidden = true
            
        }
        self.lblTitle.text = indicator.Nombre
        if style.FormatoIndicador.Simbolo == "#" {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            let fortm = formatter.string(from: NSNumber(value: indicator.Valor))!
            var aux = ""
            var point = false
            print(fortm)
            for c in fortm{
                if "$" != "\(c)" {
                if "." == "\(c)" {
                    point = true
                }
                if point{
                    
                }else{
                    aux += "\(c)"
                }
                }
            }
            self.lblValue.text = "\(aux)"
        }else{
            
        self.lblValue.text = style.FormatoIndicador.Simbolo == "$" ? " \(self.getValueFormatterDecimal(decimal: style.FormatoIndicador.Decimal, value: indicator.Valor))":"\(Int(indicator.Valor))\(style.FormatoIndicador.Simbolo)"
        }
          //print("\(indicator.Nombre) - \(style.FormatoIndicador.Simbolo) \(indicator.Valor) - \(style.FormatoIndicador.Decimal)" )
    }
    func getValueFormatterDecimal(decimal: Int, value: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        switch decimal {
        case 1:
           formatter.maximumFractionDigits = 1
        return "\(formatter.string(from: NSNumber(value: value))!)"
          
        case 2:
            formatter.maximumFractionDigits = 2
            return "\(formatter.string(from: NSNumber(value: value))!)"
            
        default :
            
            let fortm = formatter.string(from: NSNumber(value: value))!
            var aux = ""
            var point = false
            print(fortm)
            for c in fortm{
                if "." == "\(c)" {
                point = true
                }
                if point{
                   
                }else{
                    aux += "\(c)"
                }
            }
            return "\(aux)"
            
            
        }
    }
    
}
