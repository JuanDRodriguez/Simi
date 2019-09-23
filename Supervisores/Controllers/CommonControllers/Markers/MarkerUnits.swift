//
//  MarkerUnits.swift
//  Supervisores
//
//  Created by Sharepoint on 29/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class MarkerUnits: UIView {
    @IBOutlet weak var componentView: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var imgMarker: UIImageView!
    let images: [Int: String] = [1: "sucursal",
                                 2: "franquicia",
                                 3: "laboratorio"]
    
    init(frame: CGRect, type: Int) {
        super.init(frame: frame)
        commonInit()
        if let image = self.images[type] {
            imgMarker.image = UIImage(named: image)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit (){
//        let view = Bundle.main.loadNibNamed("MarkerUnits", owner: self, options: nil)![0] as! MarkerUnits
//        view.frame = frame
//        self.addSubview(view)
        
        Bundle.main.loadNibNamed("MarkerUnits", owner: self)
        self.addSubview(componentView)
        componentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
