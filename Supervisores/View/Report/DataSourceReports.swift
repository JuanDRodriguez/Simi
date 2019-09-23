//
//  DataSourceReports.swift
//  Supervisores
//
//  Created by Sharepoint on 8/15/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

extension ReportsView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return items.count
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: PeguntasCollectionCell.reuseIdentifier, for: indexPath) as! PeguntasCollectionCell
        cell.display(items: items[indexPath.item], id:indexPath.item )
            cell.delegate = self
        return cell
    }
    
    
}
