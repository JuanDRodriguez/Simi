//
//  EncuestaView.swift
//  Supervisores
//
//  Created by Sharepoint on 8/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class EncuestaView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    var items:[Question] = []
    var itemAction: (([ResponseEncuesta],[PhotosView]) -> Void)?
    var response:[ResponseEncuesta] = []
    var photosView: [PhotosView] = []
    var vc: UIViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
       collectionView.register(EscuestaCell.nib, forCellWithReuseIdentifier: EscuestaCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}
extension EncuestaView: EncuentaViewInput{
    func display(_ items: [Question]) {
        self.items = items
        setDataCell(count: items.count)        
        collectionView.reloadData()
    }
    
}
