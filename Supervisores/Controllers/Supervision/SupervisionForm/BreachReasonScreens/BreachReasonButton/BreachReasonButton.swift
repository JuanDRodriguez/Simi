//
//  BreachReasonButton.swift
//  Supervisores
//
//  Created by Sharepoint on 13/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie
class BreachReasonButton: UIView {
    @IBOutlet weak var animationView: UIView!
    var lottieView = LOTAnimationView(name: "addJson")
    var updateContrains = false
    var lottieCreated = false
    let goToBreach: ()->Void
    
    init(frame: CGRect, goToBreach: @escaping ()->Void) {
        self.goToBreach = goToBreach
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("BreachReasonButton", owner: self, options: nil)![0] as! BreachReasonButton
        view.frame = self.bounds
        self.addSubview(view)
        self.layoutIfNeeded()
        self.backgroundColor = .blue
        self.updateContrains = true
    }
    required init?(coder aDecoder: NSCoder) {
        self.goToBreach = {}
        super.init(coder: aDecoder)
    }
    override func updateConstraints() {
        super.updateConstraints()
        if updateContrains && !lottieCreated {
            if let _ = self.animationView {
                self.loadLottieAnimation()
            }
        }
    }

    func loadLottieAnimation() {
        self.lottieCreated = true
        self.animationView.layer.masksToBounds = true
        self.lottieView.animationSpeed = 2
        self.lottieView.isUserInteractionEnabled = false
        let lottieSize = self.animationView.frame.width * 0.7
        self.lottieView.frame = CGRect(x: 0.0, y: 0.0, width: lottieSize, height: lottieSize)
        self.lottieView.center = CGPoint(x: self.animationView.frame.width / 2.0,
                                         y: self.animationView.frame.height / 2.0)
        self.animationView.addSubview(self.lottieView)
        self.lottieView.setProgressWithFrame(0)
    }
    
    func setBreachReasonfinish(finished: Bool){
        
        if finished {
            print("TERMINADO!!!!")
            Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 180)
        } else {
            self.lottieView.setProgressWithFrame(0)
        }
    }
    @IBAction func goToBreachReason(_ sender: Any) {
        self.goToBreach()
    }
}
