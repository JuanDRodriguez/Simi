//
//  VisitDataSource.swift
//  Supervisores
//
//  Created by Sharepoint on 7/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class VisitDataSoruce: NSObject {
    var textView: UITextView!
    var items: [ReasonItem] = []
    var itemsSelected:[(Bool,Int)] = []
    var photosView: PhotosView!
    func setVC(vc: UIViewController){
        var photosView: PhotosView = PhotosView(frame: CGRect.init(x: 0, y: 0, width: 350, height: 90), questionId: 1,type: .visita,vc: vc)
    }
    func setSelected(){
        for i in 0 ..< items.count{
            
            itemsSelected.append((false,items[i].MotivoId!))
        }
    }
    
}
extension VisitDataSoruce: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (items.count == 0 ? 0:items.count + 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == items.count + 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellVisit.reuseIdentifier, for: indexPath) as! CollectionViewCellVisit
            cell.displayPhoto(photos: photosView)
            
            return cell
        }
        else if indexPath.item == items.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellVisit.reuseIdentifier, for: indexPath) as! CollectionViewCellVisit
            cell.displayComment()
            self.textView = cell.textView
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellVisit.reuseIdentifier, for: indexPath) as! CollectionViewCellVisit
            cell.delegate = self
            cell.display(item: items[indexPath.item].Nombre!,index: indexPath.item)
            
            return cell
        }
        
      
    }
    
    
}
extension VisitDataSoruce: CollectionViewCellVisitDelegate{
    func selctedBox(index: Int, status: Bool) {
        itemsSelected[index] = (status,items[index].MotivoId!)
    }
    
    
}
