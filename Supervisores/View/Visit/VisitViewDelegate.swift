//
//  VisitViewDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 7/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension VisitView: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.cellForItem(at: indexPath)
        var cgsize = CGSize(width: 175, height: 50)
        let size = dataSource.items.count
        if indexPath.item == size{
            cgsize = CGSize(width: 350, height: 130)
        }else if indexPath.item == size + 1{
             cgsize = CGSize(width: 350, height: 90)
           
        }else if dataSource.items.count - 1 == indexPath.item{
            if (dataSource.items.count % 2) != 0{
                cgsize = CGSize(width: 350, height: 50)
            }
            
        }
        
        return cgsize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5.0)
    }
    
}
