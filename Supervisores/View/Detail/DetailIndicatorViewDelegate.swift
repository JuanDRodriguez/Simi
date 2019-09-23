//
//  DetailIndicatorViewDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 7/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension DetailIndicatorView: UITableViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
        DispatchQueue.main.async {
            self.dataSource.items = self.dataSource.items
            self.dataSource.itemStyle = self.dataSource.itemStyle
             self.tableView.reloadData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
    }
   @IBAction func actionChangeTypeFormatter(button: UIButton){
    formatterAction?((button.titleLabel?.text!)!)
    }
    @IBAction func actionChangeDataView(button: UIButton){
         chageTabViewController(id: Int(button.titleLabel!.text!)!)
        setBlockHeader()
    }
    func setBlockHeader(){
        if Operation.statusF == 0 {
            lblFranquicia.alpha = CGFloat(0.3)
            tbnF.alpha = CGFloat(0.3)
            tbnF.isEnabled = false
        }
        if Operation.statusS == 0 {
            lblSucursal.alpha = CGFloat(0.3)
            tbnS.alpha = CGFloat(0.3)
            tbnS.isEnabled = false
        }
    }
    func chageTabViewController(id: Int){
        switch id {
        case 1:
            lblTotal.textColor = #colorLiteral(red: 0.02701364437, green: 0.5163402289, blue: 1, alpha: 1)
            lblSucursal.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblFranquicia.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lineTotal.backgroundColor = #colorLiteral(red: 0.02701364437, green: 0.5163402289, blue: 1, alpha: 1)
            lineSucursal.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lineFranquicia.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            itemAction?(.all)
            break
        case 2:
            lblSucursal.textColor = #colorLiteral(red: 0.02701364437, green: 0.5163402289, blue: 1, alpha: 1)
            lblTotal.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblFranquicia.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lineTotal.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lineSucursal.backgroundColor = #colorLiteral(red: 0.02701364437, green: 0.5163402289, blue: 1, alpha: 1)
            lineFranquicia.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            itemAction?(.branch)
            
            break
        case 3:
            lblSucursal.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblTotal.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblFranquicia.textColor = #colorLiteral(red: 0.02701364437, green: 0.5163402289, blue: 1, alpha: 1)
            lineTotal.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lineSucursal.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lineFranquicia.backgroundColor = #colorLiteral(red: 0.02701364437, green: 0.5163402289, blue: 1, alpha: 1)
            itemAction?(.franchise)
            
        default:
            break
        }
    }
}
