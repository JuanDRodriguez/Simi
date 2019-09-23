//
//  PickerElement.swift
//  Supervisores
//
//  Created by Sharepoint on 20/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class PickerElement: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    init(text: String, frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("PickerElement", owner: self, options: nil)![0] as! PickerElement
        view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(view)
        self.lblTitle.text = text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.frame.size.height = self.lblTitle.frame.height
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
