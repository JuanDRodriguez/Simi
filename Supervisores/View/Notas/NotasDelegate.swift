//
//  NotasDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension NotasView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(60)
    }
}
