//
//  EncuestasView.swift
//  Supervisores
//
//  Created by Sharepoint on 8/29/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class EncuestasView: UIView{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
      var itemAction: ((EncuestasItem) -> Void)?
    var dataSource: EncuestasDataSource!  {
        didSet{
            collectionView.dataSource = dataSource
            collectionView2.dataSource = dataSource
            dataSource.collectionViewOrigin = collectionView
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(EncuestasCell.nib, forCellWithReuseIdentifier: EncuestasCell.reuseIdentifier)
        collectionView2.register(EncuestasCell.nib, forCellWithReuseIdentifier: EncuestasCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView2.delegate = self
        
    }
}
extension EncuestasView: EncuentasViewInput {
    
    func display(_ items: ([EncuestasItem], [String:Int])) {
        DispatchQueue.main.async {
            self.dataSource.items = items.0.filter({$0.DESTINATARIO == "E"})
            self.dataSource.items2 = items.0.filter({$0.DESTINATARIO == "C"})
            self.dataSource.itemCounts = items.1
        self.collectionView.reloadData()
        self.collectionView2.reloadData()
        }
    }
    
}
