//
//  DetailIndicatorStyle.swift
//  Supervisores
//
//  Created by Sharepoint on 7/11/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension DetailIndicatorView{
    func configureHeader(from: fromBuild){
        let aux = from == .unitIndicators ?  true :  false
        headerView.isHidden = aux
    }
   
    func configViewButton(firstColor: UIColor!, secondColor: UIColor!){
        btnMoney.layer.cornerRadius = CGFloat(10.0)
        btnMoney.layer.borderColor = #colorLiteral(red: 0.01960784314, green: 0.5764705882, blue: 0.9764705882, alpha: 1).cgColor
        btnMoney.clipsToBounds = true
        btnMoney.layer.borderWidth = 1
        btnMoney.backgroundColor = secondColor
        btnMoney.tintColor = firstColor
        
        btnPercentage.backgroundColor = firstColor
        btnPercentage.tintColor = secondColor
        btnPercentage.layer.cornerRadius = CGFloat(10.0)
        btnPercentage.layer.borderColor = #colorLiteral(red: 0.02745098039, green: 0.5176470588, blue: 1, alpha: 1).cgColor
        btnPercentage.clipsToBounds = true
        btnPercentage.layer.borderWidth = 1
    }
    func ConfigureBorderView(){
        contentViewGraph.layer.masksToBounds = true
        contentViewGraph.layer.cornerRadius = CGFloat(10.0)
        contentViewGraph.clipsToBounds = true
        contentViewGraph.layer.borderWidth = 0.5
        contentViewGraph.layer.borderColor = UIColor.gray.cgColor
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = CGFloat(10.0)
        tableView.clipsToBounds = true
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.gray.cgColor
    }
    func configureLabelGraph(symbol: String, items: [IndicatorItem], time: [String]){
        for index in 0...2{
            let indicatorActual = items[3 + index].Valor
           var indicatorLast = items[index].Valor
            if indicatorLast == 0{
                indicatorLast = 1
            }
            let increase = symbol == "%" ? (indicatorActual * 100 / indicatorLast)-100 : indicatorActual - indicatorLast
            let contentLabels = [self.lblLast, self.lblCurrent, self.lblNext]
            if symbol == "%"{
                contentLabels[index]?.text = String(format: "%d %@\n%@", Int(increase),symbol,time[index])
            }else{
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.currency
                formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
                let string = formatter.string(from: NSNumber(value: increase))!
                var result = ""
                for c in string{
                    if "$" != "\(c)" {
                         result += "\(c)"
                    }
                   
                }
                    contentLabels[index]?.text = string
                
               // contentLabels[index]?.text = String(format: "%@%.2lf \n%@", symbol,increase,time[index])
            }
            
        }
    }
}
