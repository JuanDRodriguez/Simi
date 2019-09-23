//
//  EncuestasViewDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 8/30/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension EncuestasView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 200, height: 225)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView2{
        itemAction?(dataSource.items2[indexPath.item])
        }else{
         itemAction?(dataSource.items[indexPath.item])
        }
    }
    
}
