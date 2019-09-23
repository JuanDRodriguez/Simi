//
//  NotasDataSource.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class NotasDataSource: NSObject {
    var items: [NotasItem] = []
    var vc: NotaCellProtocol!
}
extension NotasDataSource: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: NotasCellTableViewCell.reuseIdentifier, for: indexPath) as! NotasCellTableViewCell
        cell.delegate = self
        cell.Display(items[indexPath.row])
        return cell
    }
    
    
}
extension NotasDataSource: NotaCellProtocol{
    func openPopUp(item: NotasItem) {
        vc.openPopUp(item: item)
    }
    
    func actEdit(item: NotasItem) {
        vc.actEdit(item: item)
    }
    
    func actDelete(item: NotasItem) {
        vc.actDelete(item: item)
    }
    
    
}
