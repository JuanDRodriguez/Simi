//
//  InfoBricksView.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/3/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class InfoBricksView: UIView {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblTown: UILabel!
    @IBOutlet weak var lblParticipation: UILabel!
    @IBOutlet weak var lblChance: UILabel!
    @IBOutlet weak var lblTotalMarket: UILabel!
    
    init(parentView: UIView) {
        let windowH : CGFloat = 195.0
        let windowY : CGFloat = parentView.bounds.size.height - windowH
        let windowW : CGFloat = parentView.bounds.size.width
        super.init(frame: CGRect(x: 0, y: windowY, width: windowW, height: windowH))
        let view = Bundle.main.loadNibNamed("InfoBricksView", owner: self, options: nil)![0] as! InfoBricksView
        view.frame = CGRect(x: 0, y: 0, width: windowW, height: windowH)
        self.addSubview(view)
        parentView.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
       self.isHidden = true
    }
    
    func setInfornation(infoBlock: [String: Any]){
        self.isHidden = false
        self.lblName.text = "\(infoBlock[KeysBrick.name.rawValue] ?? "")"
        self.lblState.text = "\(infoBlock[KeysBrick.state.rawValue] ?? "")"
        self.lblTown.text = "\(infoBlock[KeysBrick.town.rawValue] ?? "")"
        self.lblParticipation.text = "\(infoBlock[KeysBrick.participation.rawValue] ?? "")"
        self.lblTotalMarket.text = "\(infoBlock[KeysBrick.totalMarket.rawValue] ?? "")"
        self.lblChance.text = "\(infoBlock[KeysBrick.chance.rawValue] ?? "")"
    }
}
