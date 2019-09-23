//
//  CollectionViewCellIndicatorTotalDataSource.swift
//  Supervisores
//
//  Created by Sharepoint on 7/5/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class IndicatorCollectionViewDataSource: NSObject {
    var items: [IndicatorResumItem] = []
    var itemsSearch: [IndicatorResumItem] = []
    var itemSearchContacto: [ContactoItem] = []
    var states: [States] = []
    var itemsUnits: [Unit] = []
    var itemsTable: [UnitLite] = []
    var itemsContacto: [ContactoItem] = []
    var collectionViewIndicator: UICollectionView!
    var collectionViewIndicator2: UICollectionView!
    var collectionViewIndicator3: UICollectionView!
    var total = Indicators.negocioTotal
    var index = 0
    var search = false
}
extension IndicatorCollectionViewDataSource: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewIndicator{
           
                return 1
           
        }else if collectionView == self.collectionViewIndicator2 {
            if self.search{
                if itemsContacto.count > 0{
                    return itemSearchContacto.count
                }else{
                return itemsSearch.count
                }
            }
            else{
                if itemsContacto.count > 0{
                   return itemsContacto.count
                }else{
           return items.count
                }
            }
        }
        if collectionView == self.collectionViewIndicator3{
            return itemsUnits.count
            
        }
        else{
            return states.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == self.collectionViewIndicator{
            
                let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIndicatorTotal.reuseIdentifier, for: indexPath) as! CollectionViewCellIndicatorTotal
                    cell.display(item: items)
                
                return cell
                
         
            //cell.
        }else if collectionView == self.collectionViewIndicator2{
            
                let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIndicator.reuseIdentifier, for: indexPath) as! CollectionViewCellIndicator
            
            if items.count > 0 && total != .negocioTotal{
                if self.search{
                     cell.display(itemsSearch[indexPath.item])
                }
                else {
                    cell.display(items[indexPath.item])
                }
                
            }else if itemsContacto.count > 0 {
                cell.display(itemsContacto[indexPath.item])
            }
                return cell
            
        }else if collectionView == self.collectionViewIndicator3{
             let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellUnit.reuseIdentifier, for: indexPath) as! CollectionViewCellUnit
                cell.setUnit(unit: itemsUnits[indexPath.item])
            return cell
        }
        else{
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
            cell.lblTitle.text = states[indexPath.item].nombre.uppercased()
            if indexPath.item == self.index{
                cell.setColorBlue()
            }else{
                cell.returnColor()
            }
        return cell
        }
        
    }
    
}
extension IndicatorCollectionViewDataSource: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellUnit.reuseIdentifier, for: indexPath) as! TableViewCellUnit
        
            cell.display(unit: itemsTable[indexPath.row])
     
        return cell
    }
    
    
}

