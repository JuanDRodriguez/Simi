//
//  PhotosView.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/13/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
enum typeOperation{
    case supervision
    case visita
}

class PhotosView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var photo1: UIButton!
    @IBOutlet weak var photo2: UIButton!
    @IBOutlet weak var photo3: UIButton!
    @IBOutlet weak var photo4: UIButton!
    @IBOutlet weak var photo5: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var viewImgOptions: UIView!
    @IBOutlet weak var stackViewPhotos: UIStackView!
    var pictureButtonCount:[Int] = [0,0,0,0,0,0]
    var type: typeOperation!
    var currentPhoto = 0
    var currenTagtButton : Int?
    var imagePicker: UIImagePickerController!
    let editPhotoVC = EditPhotoViewController()
    let waterMark = WaterMarkView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    let questionId: Int
    var vc: UIViewController!
    init(frame: CGRect, questionId: Int, type: typeOperation,vc: UIViewController) {
        self.vc = vc
         self.imagePicker =  UIImagePickerController()
        self.type = type
        self.questionId = questionId
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("PhotosView", owner: self, options: nil)![0] as! PhotosView
        view.frame = self.bounds
        self.addSubview(view)
        self.layoutIfNeeded()
        self.photo1.imageView?.contentMode = .scaleAspectFit
        self.photo2.imageView?.contentMode = .scaleAspectFit
        self.photo3.imageView?.contentMode = .scaleAspectFit
        self.photo4.imageView?.contentMode = .scaleAspectFit
        self.photo5.imageView?.contentMode = .scaleAspectFit
        self.btnGallery.imageView?.contentMode = .scaleAspectFit
        self.btnPhoto.imageView?.contentMode = .scaleAspectFit
        self.viewImgOptions.alpha = 0
        self.photo2.isHidden = true
        self.photo3.isHidden = true
        self.photo4.isHidden = true
        self.photo5.isHidden = true
        self.editPhotoVC.delegate = self
        //        self.addPhoto.addTarget(self, action:  #selector(self.addPhoto(_:)), for: .touchUpInside)
        self.imagePicker.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        self.imagePicker =  UIImagePickerController()
        
        self.questionId = -1
        super.init(coder: aDecoder)
    }
    @IBAction func addPhoto(_ sender: Any) {
        if let button = sender as? UIButton {
            if currentPhoto > button.tag - 1 {
                if let image = button.imageView?.image {
                    self.currenTagtButton = button.tag
                    self.parentViewController?.present(self.editPhotoVC, animated: true, completion: nil)
                    self.editPhotoVC.setImage(image: image)
                    self.editPhotoVC.setCurrentTagPhoto(tag: button.tag)
                    return
                }
            }
        }
        UIView.animate(withDuration: 0.5, animations: {[unowned self] in
            self.viewImgOptions.alpha = 1
        })
    }
    @IBAction func imgFromPhoto(_ sender: Any) {
       DispatchQueue.main.async {
        
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.delegate = self
        UIView.animate(withDuration: 0.5, animations: {[unowned self] in
            self.viewImgOptions.alpha = 0
        })
        self.imagePicker.sourceType = .camera
           
        self.imagePicker.allowsEditing = true
        self.imagePicker.showsCameraControls = true
        self.parentViewController?.present(self.imagePicker, animated: true, completion: nil)
     
       
        }
       
    }
    @IBAction func imgFromGallery(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {[unowned self] in
            self.viewImgOptions.alpha = 0
        })
        self.imagePicker.sourceType = .photoLibrary
        self.parentViewController?.present(imagePicker, animated: true, completion: nil)
    }
    func setTitle(title: String) {
        self.lblTitle.text = title
    }
    func setPhotos(images:[UIImage]) {
        for image in images {
            self.currentPhoto += 1
            if let button = self.stackViewPhotos.viewWithTag(self.currentPhoto) as? UIButton {
                button.isHidden = false
                button.setImage(image, for: .normal)
               
            }
            if let button = self.stackViewPhotos.viewWithTag(self.currentPhoto + 1) as? UIButton {
                button.isHidden = false
               
            }
        }
    }
}
