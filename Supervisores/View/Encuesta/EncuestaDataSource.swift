//
//  EncuestaDataSource.swift
//  Supervisores
//
//  Created by Sharepoint on 8/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension EncuestaView: UICollectionViewDataSource,didSelectOptionEncuesta{
    func didselectedSingleOption(idResp: [Int], index: Int) {
        response[index].idRespuestas = idResp
    }
    
    func didselectedMultipleOption(idResp: [Int], index: Int, indexA: Int) {
        response[index].idRespuestas[indexA] = idResp[0]
    }
    
    func didSelectedFreeOption(resp: String, index: Int) {
        response[index].respuestLibre = resp
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EscuestaCell.reuseIdentifier, for: indexPath) as! EscuestaCell
        cell.delegate = self
        cell.display(type: QuestionTypes(rawValue: items[indexPath.item].typeId)!, question: items[indexPath.item],photosView: photosView[indexPath.item],index: indexPath.item)
        return cell
    }
    
    
}
