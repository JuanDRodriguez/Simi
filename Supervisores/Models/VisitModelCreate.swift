//
//  VisitModelCreate.swift
//  Supervisores
//
//  Created by Sharepoint on 8/7/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//
import UIKit
extension VisitModel{
    func getImageFromPhotos(photos: PhotosView) -> [Photo]{
         var items: [Photo] = []
        if photos.photo1.isHidden == false {
            if photos.pictureButtonCount[1] == 1{
                items.append(Photo.init(image: photos.photo1.currentImage!))
            }
        }
        if  photos.photo2.isHidden == false{
            if  photos.pictureButtonCount[2] == 1 {
                 items.append(Photo.init(image: photos.photo2.currentImage!))
            }
        }
        if photos.photo3.isHidden == false{
            if photos.pictureButtonCount[3] == 1  {
                 items.append(Photo.init(image: photos.photo3.currentImage!))
            }
        }
        if photos.photo4.isHidden == false{
            if photos.pictureButtonCount[4] == 1
            {
                 items.append(Photo.init(image: photos.photo4.currentImage!))
            }
        }
        if photos.photo5.isHidden == false{
            if photos.pictureButtonCount[5] == 1
            {
                 items.append(Photo.init(image: photos.photo5.currentImage!))
            }
        }
        return items
    }
    func getMotivosFromSelected(motivos: [(Bool,Int)])-> [[String : Int]]{
        var items: [[String : Int]] = []
        for i in 0 ..< motivos.count  {
            if motivos[i].0{
                let dict = ["MotivoId": motivos[i].1]
                items.append(dict)
            }
        }
        return items
    }
    func orderByTypeVisit(items:[ReasonItem]){
        var resulItems: [ReasonItem] = []
        var hFin: String = ""
        var hIni: String = ""
        var isNocturna: Bool = false
        for i  in 0 ..< items.count  {
            if items[i].TipoVisitaId == 1 {
                hIni = (items[i].TipoVista?.HoraInicio!)!
                hFin = (items[i].TipoVista?.HoraFin!)!
                isNocturna = Utils.dateCampareToDateNow(stringDate: (hIni,hFin))
                
            }
        }
        for i in 0 ..< items.count {
            
            if isNocturna{
                resulItems.append(items[i])
            }else{
                if items[i].TipoVisitaId! == 2{
                    resulItems.append(items[i])
                }
                
            }}
        
        out.modelDidLoad(resulItems)
    }
    func createVisist(json: [String : Any]){
        NetworkingServices.shared.postVisit(supervisionInfo: json){
            [unowned self] in
            
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidFail()
                print("Error", parsingError)
            }
            do{
                self.out.modelDidLoadSend()
            }
            catch let error{
                self.out.modelDidFail()
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
    func getPhotos(photos:[Photo], item: (Int,String,String), completion: @escaping([[String: Any]])->Void) {
        //      {
        //          "Url": "string"
        //      }
        var arrPhotos : [[String: Any]] = []
        var imagesFromQuestion : [UIImage] = []
        for photo in photos {
            let image = Utils.base64ToImage(base64String: photo.base64Photo)
            imagesFromQuestion.append(image)
        }
        if imagesFromQuestion.count == 0 {
            completion([])
            return
        }
        
        NetworkingServices.shared.uploadImage(images: imagesFromQuestion, clave: item.0, date: item.2, tipo: item.1) {
            if let error = $1 {
                print("ERROR ==> \(error)")
                self.out.modelDidFail()
                return
            }
            if let dataPhoto = $0 {
                do {
                    let decoder = JSONDecoder()
                    let photoUpload = try decoder.decode(PhotoUpload.self, from: dataPhoto)
                    for url in photoUpload.urlImage {
                        let dicto:[String: Any] = [
                            "Url": url
                        ]
                        arrPhotos.append(dicto)
                    }
                    completion(arrPhotos)
                } catch let error {
                    completion([])
                    self.out.modelDidFail()
                    print("ERROR == PHOTOS>> \(error)")
                }
            } else {
               
                return
            }
        }
    }
}
