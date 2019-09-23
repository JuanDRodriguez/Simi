//
//  IncidenciasPopUp.swift
//  Supervisores
//
//  Created by Sharepoint on 8/7/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class IncidenciasPopUp: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnAcep: UIButton!
    var pickOption : [Incumplimientositem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAcep.layer.masksToBounds = true
        btnAcep.layer.cornerRadius = CGFloat(8.0)
        btnAcep.clipsToBounds = true
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.viewContent.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showAnimate()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row].EstatusSeguimiento
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }
    @IBAction func actClose(){
    self.removeAnimate()
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
    


}
