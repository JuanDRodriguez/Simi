//
//  EncuestasDataSource.swift
//  Supervisores
//
//  Created by Sharepoint on 8/29/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class EncuestasDataSource: NSObject {
    var items: [EncuestasItem] = []
    var items2: [EncuestasItem] = []
    var itemCounts: [String:Int] = [:]
    var collectionViewOrigin: UICollectionView!
}
extension EncuestasDataSource: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionViewOrigin == collectionView{
            return items.count
        }else{
            return items2.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionViewOrigin == collectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EncuestasCell.reuseIdentifier, for: indexPath) as! EncuestasCell
             let c = itemCounts["\(items[indexPath.item].EncuestaId!)"] ?? 0
            cell.display(items[indexPath.item],count: itemCounts["\(items[indexPath.item].EncuestaId!)"]!)
        
        return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EncuestasCell.reuseIdentifier, for: indexPath) as! EncuestasCell
             let c = itemCounts["\(items2[indexPath.item].EncuestaId!)"] ?? 0
            cell.display(items2[indexPath.item],count: c)
            return cell
        }
    }
    
    
}
