//
//  SupervisionViewController+CVDataSource.swift
//  Supervisores
//
//  Created by Sharepoint on 05/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension SupervisionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modulesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let module = self.modulesList[indexPath.row]
        let image = module[KeysModule.image.rawValue] as! UIImage
        let name = module[KeysModule.name.rawValue] as? String ?? ""
        let percent = module[KeysModule.percentFinish.rawValue] as? Int ?? 0
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.supervisionCell.rawValue, for:indexPath) as? SupervisionItemCollectionViewCell else {
            let cellCreated = SupervisionItemCollectionViewCell()
            cellCreated.setModuleInfo(image: image, title: name, percentFinish: percent)
            return cellCreated
        }
        
        cell.setModuleInfo(image: image, title: name, percentFinish: percent)
        cell.updateCornerRadius(radius: self.cornerRadius)
        return cell
    }
}
