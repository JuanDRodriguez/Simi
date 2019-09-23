//
//  PickerDateView.swift
//  Supervisores
//
//  Created by Sharepoint on 19/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

protocol PickerDateViewDelegate: class{
    func selectDate(date: Date)
}

class PickerDateView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBOutlet weak var btnDone: UIButton!
    var pickerView: PickerSelectView? = nil
    weak var delegate: PickerDateViewDelegate?
    var option = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("PickerDateView", owner: self, options: nil)![0] as! PickerDateView
        view.frame = frame
        self.addSubview(view)
        self.pickerDate.minimumDate = Date()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitle(title: String){
        self.lblTitle.text = title
    }
    
    @IBAction func newDate(_ sender: Any) {
        
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        self.delegate?.selectDate(date: self.pickerDate.date)
    }
}
