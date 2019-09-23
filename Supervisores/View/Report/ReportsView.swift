//
//  ReportsView.swift
//  Supervisores
//
//  Created by Sharepoint on 8/15/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class ReportsView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    var items: [Modulos] = []
    var motivos: ([Int],[Int])!
    var itemsChange: (Int,Int,[Int])!
    var dictoIncum: [[String: Int]] = []
    var itemAction: (() -> Void)?
    var itemActionSend: (([[String : Int]]) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "PeguntasCollectionCell", bundle: nil), forCellWithReuseIdentifier: PeguntasCollectionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    @IBAction func didSelectedSave(){
        itemActionSend?(dictoIncum)
    }
    
}
extension ReportsView: ReportsViewInput{
    
    
    func displayUpdate(_ item: Int, status: String) {
        setChanges(idStatus: item, status: status)
    }
    
    func display(_ items: ReportItem) {
        self.items = items.modulos!
        collectionView.reloadData()
    }
    
    
}
