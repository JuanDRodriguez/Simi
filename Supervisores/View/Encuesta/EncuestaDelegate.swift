//
//  EncuestaDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 8/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
extension EncuestaView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         guard let questionType = QuestionTypes(rawValue: items[indexPath.item].typeId) else {return CGSize.init(width: collectionView.bounds.size.width, height: 100)}
        var h = 0
        if items[indexPath.item].photo{
            h = 100
        }
        switch questionType {
        case .binary:
            h += 100
            break
        case .threeOptions:
            h += 100
            break
        case .multipleChoice:
            if items[indexPath.item].options.count > 2{
               h += 100
            }else{
            h += 100
            }
            break
        case .emoji:
            h += 154
            break
        case .stars:
            h += 154
            break
        default:
            h += 150
            break
        }
        return CGSize.init(width: collectionView.bounds.size.width, height: CGFloat(h))
    }
    func setDataCell(count: Int){
        for i in 0 ..< count{
            self.photosView.append(PhotosView(frame: CGRect.init(x: 0, y: 0, width: 350, height: 90), questionId: 1,type: .visita,vc: self.vc))
            if items[i].typeId == 3{
                var ids: [Int] = []
                for j in 0 ..< items[i].options.count{
                    ids.append(-1)
                }
response.append(ResponseEncuesta.init(idRespuestas: ids, idPregunta:items[i].id, respuestaLibre: ""))
            }else{
               response.append(ResponseEncuesta.init(idRespuestas: [-1], idPregunta: items[i].id, respuestaLibre: ""))
            }
        }
    
    }
    @IBAction func actSend(){
       self.itemAction?(response,photosView)
    }
    
}
struct ResponseEncuesta {
    var idPregunta: Int
    var idRespuestas: [Int]
    var respuestLibre: String
    
    init(idRespuestas: [Int], idPregunta: Int, respuestaLibre: String ) {
        self.idPregunta = idPregunta
        self.idRespuestas = idRespuestas
        self.respuestLibre = respuestaLibre
    }
}
