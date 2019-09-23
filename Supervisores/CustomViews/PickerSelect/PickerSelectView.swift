//
//  PickerSelectView.swift
//  Supervisores
//
//  Created by Sharepoint on 15/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

protocol PickerSelectViewDelegate: class{
    func selectOption(_ option: Int, value: String)
    func cancelOption()
}

class PickerSelectView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var pickerV: UIPickerView!
    
    weak var delegate: PickerSelectViewDelegate?
    var dataPicker: [String]
    var option = 0
    init(dataPicker: [String], frame: CGRect) {
        self.dataPicker = dataPicker
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("PickerSelectView", owner: self, options: nil)![0] as! PickerSelectView
        view.frame = frame
        self.btnCancel.isHidden = true
        self.addSubview(view)
    }
    required init?(coder aDecoder: NSCoder) {
        self.dataPicker = []
        super.init(coder: aDecoder)
    }
    func updateOptions(options: [String]){
        DispatchQueue.main.async {
            self.dataPicker = options
            self.pickerV.reloadAllComponents()
        }
    }
    func setTitle(title: String) {
        self.lblTitle.text = title
    }
    func showCancelButton() {
        self.btnCancel.isHidden = false
    }
    @IBAction func chooseOption(_ sender: Any) {
        self.delegate?.selectOption(self.option, value: self.dataPicker[self.option])
    }
    @IBAction func cancelOption(_ sender: Any) {
        self.delegate?.cancelOption()
    }
}
