//
//  dataSourceDataPicker.swift
//  Supervisores
//
//  Created by Sharepoint on 7/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class DataSourcePickerView: NSObject {
    var items: [String] = []
}
extension DataSourcePickerView: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    
}
