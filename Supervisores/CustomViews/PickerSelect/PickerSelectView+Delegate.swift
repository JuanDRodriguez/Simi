//
//  PickerSelectView+Delegate.swift
//  Supervisores
//
//  Created by Sharepoint on 15/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension PickerSelectView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 70)
        let pickerView: PickerElement
        if let title = self.dataPicker[row] as? String {
            pickerView = PickerElement(text: title, frame: frame)
        }else{
            pickerView = PickerElement(text: "", frame: frame)
        }
        return pickerView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.option = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
}
