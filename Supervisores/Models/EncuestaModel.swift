//
//  EncuestaModel.swift
//  Supervisores
//
//  Created by Sharepoint on 8/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class EncuestaModel: EncuestaModelInput {
   var json: [String : Any] = [:]
    var idUnit: Int = 1
    func sendEncuesta(items: [ResponseEncuesta], photos: [PhotosView]) {
        setDictionary(items: items)
        
        let itm = getImageFromPhotos(photosView: photos,itemsR: items)
        let arrayPhotos = itm.0
        let ids = itm.1
        if arrayPhotos.count > 0{
            self.getPhotos(photos: arrayPhotos, item: (ids[0],"Encuesta",Utils.stringFromDateNowName())){
                [unowned self] in
                if $0.count > 0{
                    self.json["Fotografias"] = $0
                  self.createEncuesta(json: self.json)
                }else{
                  self.out.modelDidLoadFail()
                }
            }
        }else{
            self.json["Fotografias"] = []
            self.createEncuesta(json: self.json)
        }
    }
    func setDictionary(items: [ResponseEncuesta]){
        var rRegular: [[String : Int]] = []
        var rAbierta: [[String : Any]] = []
        for item in items {
            if item.respuestLibre != ""{
                var json: [String: Any] = [:]
                json["RespuestaAbierta"] = item.respuestLibre
                json["PreguntaId"] = item.idPregunta
                rAbierta.append(json)
            }else{
                for itm in item.idRespuestas{
                    if itm != -1{
                    rRegular.append(["OpcionId" : itm])
                    }
                }
            }
        }
        self.json["RespuestaRegular"] = rRegular
        self.json["RespuestaAbierta"] = rAbierta
    }
    var out: EncuestaModelOutput!
    func load(id: Int) {
        NetworkingServices.shared.getEncuesta(id: id){
            [unowned self] in
            if let error = $1 {
                self.out.modelDidLoadFail()
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.out.modelDidLoadFail()
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidLoadFail()
                print("Error", parsingError.localizedDescription)
            }
            do {
                let decoder = JSONDecoder()
                var questions = try decoder.decode([Question].self, from: data)
                self.out.modelDidLoad(questions)
            }
             catch  {
                
                self.out.modelDidLoadFail()
            }
        
        }
    }
    func getImageFromPhotos(photosView: [PhotosView],itemsR: [ResponseEncuesta]) -> ([Photo],[Int]){
        var items: [Photo] = []
        var item: [Int] = []
        var i = 0
        for photos in photosView{
        if photos.photo1.isHidden == false {
            if photos.pictureButtonCount[1] == 1{
                items.append(Photo.init(image: photos.photo1.currentImage!))
                item.append(itemsR[i].idPregunta)
                
            }
        }
        if  photos.photo2.isHidden == false{
            if  photos.pictureButtonCount[2] == 1 {
                items.append(Photo.init(image: photos.photo2.currentImage!))
                item.append(itemsR[i].idPregunta)
            }
        }
        if photos.photo3.isHidden == false{
            if photos.pictureButtonCount[3] == 1  {
                items.append(Photo.init(image: photos.photo3.currentImage!))
                item.append(itemsR[i].idPregunta)
            }
        }
        if photos.photo4.isHidden == false{
            if photos.pictureButtonCount[4] == 1
            {
                items.append(Photo.init(image: photos.photo4.currentImage!))
                item.append(itemsR[i].idPregunta)
            }
        }
        if photos.photo5.isHidden == false{
            if photos.pictureButtonCount[5] == 1
            {
                items.append(Photo.init(image: photos.photo5.currentImage!))
                item.append(itemsR[i].idPregunta)
            }
            }
            i += 1
        }
        return (items,item)
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
                    
                    print("ERROR == PHOTOS>> \(error)")
                }
            } else {
                
                return
            }
        }
    }
    func createEncuesta(json:[String:Any]){
        NetworkingServices.shared.posEncuestas(param: json){
            [unowned self] in
            
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidLoadFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidLoadFail()
                print("Error", parsingError)
            }
            do{
                var son: [String:Any] = [:]
                son["UsuarioId"] = LoginViewModel.shared.loginInfo?.user?.userId
                son["EncuestaId"] = EncuestaViewController.idEncuesta
                son["UnidadNegocioId"] = self.idUnit
                
                self.postEncuestaId(json: son)
            }
            catch let error{
                self.out.modelDidLoadFail()
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
    func postEncuestaId(json: [String:Any]){
        NetworkingServices.shared.postEncuestasUsuario(param: json ){
            [unowned self] in
            
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    self.out.modelDidLoadFail()
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                self.out.modelDidLoadFail()
                print("Error", parsingError)
            }
            do{
                EncuestasModel.shared.getScore()
                self.out.modelDidLoadFinish()
                
            }
            catch let error{
                self.out.modelDidLoadFail()
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
}
