//
//  PickerSelectView+Datasource.swift
//  Supervisores
//
//  Created by Sharepoint on 15/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension PickerSelectView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataPicker.count
    }
}
