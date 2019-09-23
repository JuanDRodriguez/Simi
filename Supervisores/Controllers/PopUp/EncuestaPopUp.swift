//
//  EncuestaPopUp.swift
//  Supervisores
//
//  Created by Sharepoint on 8/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class EncuestaPopUp: UIViewController {
    @IBOutlet weak var lblInstrucciones: UILabel!
    @IBOutlet weak var btnInit: UIButton!
    @IBOutlet weak var tfNombreCompleto: UITextField!
    @IBOutlet weak var tfFecha: UITextField!
    @IBOutlet weak var imgF: UIImageView!
    @IBOutlet weak var imgM: UIImageView!
     let datePicker: UIDatePicker = UIDatePicker()
    var delegate: InstruccionesEncuestasProtocol!
    var instruccciones: InstruccionesItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        lblInstrucciones.text = "Instrucciones: \n \(instruccciones.Instrucciones!)"
        self.setupDatePicker()
         self.view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        
        self.view.endEditing(true)
        self.view.frame.origin.y = 0
    }
    @objc func keyboardShow ( notification: Notification){
        self.view.frame.origin.y = 0
    }
    @objc func keyboardDidShow ( notification: Notification){
        self.view.frame.origin.y = -20
        
    }
    @IBAction func onClick(sender: UIButton){
        if sender.tag == 1 {
            imgF.image = UIImage(named: "checkBoxTrue")
            imgM.image = UIImage(named: "checkBoxFalse")
        }else{
            imgF.image = UIImage(named: "checkBoxFalse")
            imgM.image = UIImage(named: "checkBoxTrue")
        }
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
    func setupDatePicker() {
        // Specifies intput type
        let loc = Locale(identifier: "es")
        self.datePicker.locale = loc
        datePicker.datePickerMode = .date
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Adds the toolbar to the view
        tfFecha.inputView = datePicker
        tfFecha.inputAccessoryView = toolBar
    }
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //dateFormatter.dateStyle = .ShortStyle
        if tfFecha.isFirstResponder == true {
            tfFecha.text = dateFormatter.string(from: datePicker.date)
            tfFecha.resignFirstResponder()
        } else {
            
        }
    }
    
    @objc func cancelClick() {
        tfFecha.resignFirstResponder()
        
    }
    @IBAction func actInit(){
        delegate.loadEncuesta()
    self.removeAnimate()
    }

}
protocol InstruccionesEncuestasProtocol {
    func loadEncuesta()
}
