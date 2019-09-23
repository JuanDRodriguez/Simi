//
//  DataSourceGeneralInfo.swift
//  Supervisores
//
//  Created by Sharepoint on 8/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class DataSourceGeneralInfo: NSObject{
    var items:[String] = []
    var item: [Service] = []
   
    var isF = true
}
extension DataSourceGeneralInfo: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GeneralInfoCell.reuseIdentifier, for: indexPath) as! GeneralInfoCell
        if items.count == indexPath.row{
            cell.display(items: item)
        }else if (items.count - 1) == indexPath.row{
            cell.display(stars: Operation.starts)
        }else{
            let index =  isF ?  (indexPath.row + 1) : indexPath.row
           cell.display(item: items[indexPath.row], index: index)
        }
        return cell
    }
    
  
    
}
extension DataSourceGeneralInfo: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  items.count == indexPath.row{
             return CGFloat.init(80.0)
        }else{
        return CGFloat.init(56.0)
        }
    }
}
