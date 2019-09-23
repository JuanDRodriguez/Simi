//
//  NotasView.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class NotasView: UIView {
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblDireccion: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnNewNota: UIButton!
    @IBOutlet weak var btnNewTask: UIButton!
    var dataSource: NotasDataSource!{
        didSet{
            tableView.dataSource = dataSource
        }
    }
    var itemAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    tableView.register(NotasCellTableViewCell.nib, forCellReuseIdentifier: NotasCellTableViewCell.reuseIdentifier)
        tableView.delegate = self
    }
    @IBAction func newNota(){
        itemAction?()
    }
    @IBAction func newTask(){
        
    }
    
}
extension NotasView: NotasViewInput{
    func display(_ items: [NotasItem]) {
        dataSource.items = items
        tableView.reloadData()
    }
    func display(_ name: String, direcc: String) {
        self.lblNombre.text = name
        self.lblDireccion.text = direcc
    }
   
}
