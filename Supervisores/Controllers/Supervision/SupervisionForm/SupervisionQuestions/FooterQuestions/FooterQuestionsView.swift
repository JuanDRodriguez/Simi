//
//  FooterQuestionsView.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/11/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class FooterQuestionsView: UIView {
    @IBOutlet weak var btnEndModule: UIButton!
    
    init(frame: CGRect, module : String) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        let nibView = Bundle.main.loadNibNamed("FooterQuestionsView", owner: self, options: nil)![0] as! FooterQuestionsView
        nibView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(nibView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func endModule(_ sender: Any) {
        
    }
    
    func endModule(){
        self.btnEndModule.setTitle("Módulo completo", for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            self.superview?.bringSubviewToFront(self)
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.superview?.frame.height ?? 400)
        })
    }
}
