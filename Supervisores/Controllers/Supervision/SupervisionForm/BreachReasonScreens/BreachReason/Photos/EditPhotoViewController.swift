//
//  EditPhotoViewController.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import NXDrawKit

protocol EditPhotoProtocol: class {
    func newImage(image: UIImage, tag: Int)
    func deletePhoto(tag: Int)
}

class EditPhotoViewController: UIViewController, CanvasDelegate {
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var btnRedo: UIButton!
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewCanvas: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    
    weak var delegate: EditPhotoProtocol?
    var currentTagPhoto = -1
    var imageDelegate : UIImage?
    var canvas: Canvas?
    let cBrush: Brush = Brush()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cBrush.width = 5
        self.cBrush.color = .blue
        self.cBrush.alpha = 1.0
        self.canvas = Canvas(canvasId: "canvasEdit", backgroundImage: nil)
        self.canvas?.backgroundColor = .clear
        self.canvas!.delegate = self
        self.viewCanvas.addSubview(self.canvas!)
        self.btnRedo.imageView?.contentMode = .scaleAspectFit
        self.btnUndo.imageView?.contentMode = .scaleAspectFit
        self.btnSave.imageView?.contentMode = .scaleAspectFit
        self.btnBack.setBackgroundImage(UIImage(named: "back"), for: .normal, barMetrics: .default)
        self.btnDelete.setBackgroundImage(UIImage(named: "delete"), for: .normal, barMetrics: .default)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.canvas!.frame = CGRect(x: 0, y: 0, width: self.viewCanvas.bounds.width, height: self.viewCanvas.bounds.height)
        self.imageDelegate = nil
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let imgD = self.imageDelegate {
            self.delegate?.newImage(image: imgD, tag: self.currentTagPhoto)
        }
    }
    func setImage(image: UIImage) {
        if self.canvas?.canClear() ?? false {
            self.canvas?.clear()
        }
        self.imgBackground.image = image
    }
    func setCurrentTagPhoto(tag: Int) {
        self.currentTagPhoto = tag
    }
    func brush() -> Brush? {
        return self.cBrush
    }
    func canvas(_ canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?) {
    }
    func canvas(_ canvas: Canvas, didSaveDrawing drawing: Drawing, mergedImage image: UIImage?) {
        if let imgTop = image,
            let imgBack = self.imgBackground.image {
            let imgMerged = imgBack.mergeImages(topImage: imgTop)
            self.imgBackground.image = imgMerged
            self.imageDelegate = imgMerged
            self.canvas?.clear()
        }
    }
    @IBAction func changeColorBrush(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let color = button.backgroundColor else { return }
        self.cBrush.color = color
    }
    @IBAction func actionUndo(_ sender: Any) {
        self.canvas?.undo()
    }
    @IBAction func actionRedo(_ sender: Any) {
        self.canvas?.redo()
    }
    @IBAction func actionSave(_ sender: Any) {
        self.canvas?.save()
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deletePhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Borrar foto", message: "¿Estas seguro de borrar la foto?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default))
        alert.addAction(UIAlertAction(title: "Borrar", style: .default, handler: {[unowned self] action in
            self.delegate?.deletePhoto(tag: self.currentTagPhoto)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
