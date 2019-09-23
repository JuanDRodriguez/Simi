//
//  ReportsDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 8/15/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension ReportsView: UICollectionViewDelegateFlowLayout, ProtocolIncumplimiento{
    func setIncumplimiento(idMotivo: ([Int],[Int]), ids: (Int,Int,[Int])) {
        self.itemsChange = ids
        self.motivos = idMotivo
        itemAction?()
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Double(self.frame.size.width), height: Double( items[indexPath.item].sizeCell))
    }
    func setChanges(idStatus: Int, status: String){
        let idPregunte = items[itemsChange.0].preguntas![itemsChange.1].id!
        for i in 0 ..< itemsChange.2.count{
            items[itemsChange.0].preguntas![itemsChange.1].motivos![itemsChange.2[i]].status = status
        }
        for i in 0 ..< motivos.0.count {
            var dicto = [String : Int]()
            dicto["EstatusId"] = idStatus
            dicto["RespuestaId"] = motivos.1[i]
            dicto["IncumplimientoId"] = motivos.0[i]
            dictoIncum.append(dicto)
        }
        
        collectionView.reloadData()
    }
}
