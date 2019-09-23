//
//  PhotosView+Delegates.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/13/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension PhotosView: UINavigationControllerDelegate,UIImagePickerControllerDelegate,
EditPhotoProtocol,CameraDelegate{
    func didTakePhoto(img: UIImage) {
        var image = img
            waterMark.updateInfo()
            let renderer = UIGraphicsImageRenderer(size: waterMark.bounds.size)
            let imageWM = renderer.image {
                ctx in
                waterMark.drawHierarchy(in: waterMark.bounds, afterScreenUpdates: true)
            }
        image = (image.mergeImages(topImage: imageWM, scale: 0.02, alpha: 0.5))
            if type == typeOperation.supervision{
                if let saveImage = Storage.shared.getOption(key: SimpleStorageKeys.saveImages.rawValue) as? Bool {
                    if saveImage {
                       
                    }
                }
            }
        if let button = self.stackViewPhotos.viewWithTag(self.currentPhoto + 1) as? UIButton {
            button.setImage(image, for: .normal)
            pictureButtonCount[self.currentPhoto + 1 ] = 1
        }
       
            
            self.newImage(image: image, tag: (self.currentPhoto + 1))
            
        
        self.currentPhoto += 1
        if let button = self.stackViewPhotos.viewWithTag(self.currentPhoto + 1) as? UIButton {
            button.isHidden = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        var image = info[.originalImage] as? UIImage
        if picker.sourceType == .camera {
            waterMark.updateInfo()
            let renderer = UIGraphicsImageRenderer(size: waterMark.bounds.size)
            let imageWM = renderer.image {
                ctx in
                waterMark.drawHierarchy(in: waterMark.bounds, afterScreenUpdates: true)
            }
            image = image?.mergeImages(topImage: imageWM, scale: 0.02, alpha: 0.5)
            if type == typeOperation.supervision{
            if let saveImage = Storage.shared.getOption(key: SimpleStorageKeys.saveImages.rawValue) as? Bool {
                if saveImage {
                    if let imgSvd = image {
                        //Utils.savePhoto(photo: imgSvd)
                     
                    }
                }
            }
            }}
        if let button = self.stackViewPhotos.viewWithTag(self.currentPhoto + 1) as? UIButton {
            button.setImage(image, for: .normal)
             pictureButtonCount[self.currentPhoto + 1 ] = 1
        }
        if let img = image {
           
            self.newImage(image: img, tag: (self.currentPhoto + 1))
             
        }
        self.currentPhoto += 1
        if let button = self.stackViewPhotos.viewWithTag(self.currentPhoto + 1) as? UIButton {
            button.isHidden = false
        }
    }
    func newImage(image: UIImage, tag: Int) {
        if let button = self.stackViewPhotos.viewWithTag(tag) as? UIButton {
            button.setImage(image, for: .normal)
            QuestionViewModel.shared.addImage(idQuestion: self.questionId, img: image, position: self.currentPhoto)
        }
    }
    func deletePhoto(tag: Int) {
        if tag < self.currentPhoto {
            for i in tag...self.currentPhoto {
                guard let firstButton = self.stackViewPhotos.viewWithTag(i) as? UIButton else { continue }
                guard let secondButton = self.stackViewPhotos.viewWithTag(i + 1) as? UIButton else { continue }
                firstButton.isHidden = false
                firstButton.setImage(secondButton.imageView?.image, for: .normal)
                secondButton.isHidden = true
                secondButton.setImage(UIImage(named: "addPhoto"), for: .normal)
            }
        } else {
            if let button = self.stackViewPhotos.viewWithTag(tag) as? UIButton {
                button.setImage(UIImage(named: "addPhoto"), for: .normal)
            }
            if let button = self.stackViewPhotos.viewWithTag(tag + 1) as? UIButton {
                button.isHidden = true
            }
        }
        self.currentPhoto -= 1
        if let button = self.stackViewPhotos.viewWithTag(self.currentPhoto + 1) as? UIButton {
            button.isHidden = false
        }
    }
}
