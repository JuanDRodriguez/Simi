//
//  VisitView.swift
//  Supervisores
//
//  Created by Sharepoint on 7/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class VisitView: UIView {
   @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSendVisit: UIButton!
    var itemAction: ((PhotosView,[(Bool,Int)],String) -> Void)?
    var dataSource: VisitDataSoruce! {
        didSet{
            
            self.collectionView.dataSource = dataSource
            
        }
    }
    override func awakeFromNib() {
    collectionView.register(UINib(nibName: "CollectionViewCellVisit", bundle: nil), forCellWithReuseIdentifier: CollectionViewCellVisit.reuseIdentifier)
        self.collectionView.delegate = self
    }
    @IBAction func actSendVisit(){
        
        for i in 0 ..< dataSource.items.count {
            //print("\(dataSource.items[i]): \(dataSource.itemsSelected[i])")
        }
       if dataSource.photosView.pictureButtonCount[1] == 1 &&  dataSource.textView.text.count > 0{
        itemAction?(dataSource.photosView,dataSource.itemsSelected,dataSource.textView.text)
       }
    }
}
extension VisitView: visitViewInput{
    
    
    func display(items: [ReasonItem]) {
        dataSource.items = items
        dataSource.setSelected()
        collectionView.reloadData()
    }
  
}
