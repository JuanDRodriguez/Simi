//
//  NuevaNotaPopUp.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class NuevaNotaPopUp: UIViewController {
    @IBOutlet weak var viewContetn: UIView!
    @IBOutlet weak var lblTitle: UITextField!
    @IBOutlet weak var lblDetail: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    var delegaete: NotaCellProtocol!
    var opertion: operationNote!
    var item: NotasItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        viewContetn.layer.masksToBounds = true
        viewContetn.layer.cornerRadius = CGFloat(8.0)
       viewContetn.clipsToBounds = true
        lblDetail.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lblDetail.layer.borderWidth = CGFloat(1.0)
        self.view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard(){
        
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showAnimate()
        if opertion == operationNote.newNota{
        btnSave.titleLabel?.text = "Guardar"
    }
        else{
            lblTitle.text = self.item.title
            lblDetail.text = self.item.detail
    btnSave.titleLabel?.text = "Actualizar"
    }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.45, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.45, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    @IBAction func close(){
        removeAnimate()
    }
    @IBAction func save(){
        if lblTitle.text! != "" && lblDetail.text! != ""{
             removeAnimate()
            if opertion == operationNote.newNota {
                delegaete.actEdit(item: NotasItem.init(idNota: -1, idUnit: -1, title: lblTitle.text!, detail: lblDetail.text!))
            }else{
                delegaete.actEdit(item: NotasItem.init(idNota: item.idNota, idUnit: item.idUnit, title: lblTitle.text!, detail: lblDetail.text!))
            }
        }
        
       
    }
}
enum operationNote{
    case newNota
    case updateNota
}

