//
//  ViewResumeBreach.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import Lottie
protocol ViewResumenBreachDelegate {
    func pressButton()
}
class ViewResumeBreach: UIView {
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var lblBreachDescription: UILabel!
    @IBOutlet weak var lblDateCompromise: UILabel!
    @IBOutlet weak var lblBreachLevel: UILabel!
    var delegate : ViewResumenBreachDelegate!
    var lottieViewAction = LOTAnimationView(name: "breach")

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        let nibView = Bundle.main.loadNibNamed("ViewResumeBreach", owner: self, options: nil)![0] as! ViewResumeBreach
        nibView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(nibView)
                
        self.lottieViewAction.loopAnimation = true
        self.lottieViewAction.animationSpeed = 0.4
        self.lottieViewAction.isUserInteractionEnabled = false
        let width = self.viewAnimation.frame.width * 1.2
        self.lottieViewAction.frame = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        self.lottieViewAction.center = CGPoint(x: self.viewAnimation.frame.width / 2.0, y: self.viewAnimation.frame.height / 2.0)
        self.viewAnimation.addSubview(self.lottieViewAction)
        self.lottieViewAction.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func pressButton()  {
        self.delegate.pressButton()
    }
    func setBreach(breach: [String: Any]) {
        self.lblBreachDescription.isHidden = true
        self.lblBreachDescription.isHidden = true
        self.lblBreachLevel.isHidden = true
        if let description = breach[KeysBreachAnswerDictoResume.description.rawValue] as? String {
            self.lblBreachDescription.text = description
            self.lblBreachDescription.isHidden = false
        }
        
        if let date = breach[KeysBreachAnswerDictoResume.dateCommitment.rawValue] as? Date {
            if date != Date.init(timeIntervalSince1970: 0) {
                self.lblDateCompromise.text = Utils.stringFromDate(date: date)
                self.lblDateCompromise.isHidden = false
            }
        }
        
        if let levelBreach = breach[KeysBreachAnswerDictoResume.levelBreach.rawValue] as? String {
            if levelBreach != "" {
                self.lblBreachLevel.text = levelBreach
                self.lblBreachLevel.isHidden = false
            }
        }
    }
}
