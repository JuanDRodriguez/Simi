//
//  DataSourceDetailIndicator.swift
//  Supervisores
//
//  Created by Sharepoint on 7/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class DataSourceDetailIndicator: NSObject {
    var items : [IndicatorItem] = []
    var itemStyle : [CatalogIndicatorItem] = []
}
extension DataSourceDetailIndicator: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("TableViewcount:\(items.count)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIndicator.reuseIdentifier, for: indexPath) as! TableViewCellIndicator
        cell.display(indicator: self.items[indexPath.row], style: self.itemStyle[indexPath.row],index: indexPath.row)
        
        return cell
    }
    
    
}
