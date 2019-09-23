//
//  GeneralInfoView.swift
//  Supervisores
//
//  Created by Sharepoint on 8/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class GeneralInfoView: UIView {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: DataSourceGeneralInfo!{
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib(nibName: "GeneralInfoCell", bundle: nil), forCellReuseIdentifier: GeneralInfoCell.reuseIdentifier)
    }
}
extension GeneralInfoView: GeneralViewInput{
    func display(items: ([String], [Service]), isFranquicia: Bool) {
        dataSource.items = items.0
        dataSource.item = items.1
        dataSource.isF = isFranquicia
        tableView.reloadData()
    }
}
