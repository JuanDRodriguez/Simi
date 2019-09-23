//
//  CollectionViewCellIndicatorTotal.swift
//  Supervisores
//
//  Created by Sharepoint on 7/5/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class CollectionViewCellIndicatorTotal: UICollectionViewCell, UITableViewDataSource {
    @IBOutlet weak var content: UIView!
    let name = ["Farmacias","Sucursales","Franquicias","Laboratorios"]
    let colors = ["#1c7ac2","#42a6fb","#87c653","#fcd966"]
    var size : [String] = []
    static var reuseIdentifier: String = "\(String(describing: self))"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblIndicatorCrease: UILabel!
    var delegate: delegateIndicatorTotal!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.isEditing = false
        
        tableView.register(UINib(nibName: "TableViewCellStore", bundle: nil), forCellReuseIdentifier: TableViewCellStore.reuseIdentifier)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(10.0)
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        tableView.dataSource = self
        self.lblIndicatorCrease.layer.masksToBounds = true
        self.lblIndicatorCrease.layer.cornerRadius = CGFloat(8.0)
        self.lblIndicatorCrease.clipsToBounds = true
        
    }
    func configComponents(){
        lblIndicatorCrease.layer.cornerRadius = CGFloat(8.0)
        lblIndicatorCrease.layer.masksToBounds = true
        lblIndicatorCrease.clipsToBounds = true
    }
    @IBAction func actIndicadors(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellStore.reuseIdentifier)
        as! TableViewCellStore
        if size.count > 0{
        cell.display(item: ["image\(name[indexPath.row])",name[indexPath.row],size[indexPath.row],colors[indexPath.row]])
        }
        return cell
    }
    func display(item:[IndicatorResumItem]){
        if item.count > 0{
            self.size.append(String((item[0].Total!)))
            self.size.append(String((item[0].Sucursales!)))
            self.size.append(String((item[0].Franquicias!)))
            self.size.append(String((item[0].Laboratorios!)))
            self.lblIndicatorCrease.text = "\(Int((item[0].Indicador16?.Valor!)!))%"
            if item[0].Indicador16!.Umbral != nil{
                self.lblIndicatorCrease.backgroundColor = UIColor.init(hexString: item[0].Indicador16!.Umbral!, alpha: 1.0)}else{
                self.lblIndicatorCrease.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            
            self.tableView.reloadData()
        }
    }
}
protocol delegateIndicatorTotal {
    func shwoDetailIndicatorTotal()
}
