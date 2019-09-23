//
//  PeguntasCollectionCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/16/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class PeguntasCollectionCell: UICollectionViewCell, ProtocolPregunta{
    @IBOutlet weak var collectionView: UICollectionView!
    static var reuseIdentifier: String = "\(String(describing: self))"
    var items: [Preguntas] = []
    var item: Modulos!
    var id: Int!
    var delegate: ProtocolIncumplimiento!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "IncumplimientosCell", bundle: nil), forCellWithReuseIdentifier: IncumplimientosCell.reuseIdentifier)
            collectionView.dataSource = self
            collectionView.delegate = self
    }
    func display(items: Modulos, id: Int){
        self.items = items.preguntas!
        self.item = items
        self.id = id
        collectionView.reloadData()
    }
    func setPregunta(idMotivo:([Int],[Int]), ids:(Int,[Int])) {
        delegate.setIncumplimiento(idMotivo: idMotivo,ids: (id,ids.0,ids.1))
    }
}
extension PeguntasCollectionCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: IncumplimientosCell.reuseIdentifier, for: indexPath) as! IncumplimientosCell
        cell.display(item: items[indexPath.item],id: indexPath.item )
        cell.display(item: item)
        cell.delegate = self
        return cell
}
}
extension PeguntasCollectionCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Double(self.frame.size.width - 5), height:  Double( item.sizeCell))
    }
}
protocol ProtocolIncumplimiento{
    func setIncumplimiento(idMotivo: ([Int],[Int]), ids: (Int,Int,[Int]))
}
