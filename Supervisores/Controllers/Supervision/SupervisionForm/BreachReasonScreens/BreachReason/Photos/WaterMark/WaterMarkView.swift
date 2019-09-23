//
//  WaterMarkView.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/13/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class WaterMarkView: UIView {
    @IBOutlet weak var lblKeyUnit: UILabel!
    @IBOutlet weak var lblNameUnit: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("WaterMarkView", owner: self, options: nil)![0] as! WaterMarkView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func updateInfo() {
        let currentSupervision = CurrentSupervision.shared.getCurrentUnit()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimePrefix: String = formatter.string(from: Date())
        self.lblDate.text = dateTimePrefix
        guard let keyUnit = currentSupervision[KeysQr.keyUnit.rawValue] as? String  else { return }
        guard let nameUnit = currentSupervision[KeysQr.nameUnit.rawValue] as? String else { return }
        if keyUnit == ""{
            
        }
        self.lblKeyUnit.text = "\(keyUnit) \(nameUnit)"
//            self.lblNameUnit.text = nameUnit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
