//
//  LottieViewController.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 1/30/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class LottieViewController: UIViewController {
    var lottieView = LOTAnimationView(name: "loader")
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.lottieView.animationSpeed = 2
        self.lottieView.frame = self.animationView.bounds
        self.animationView.addSubview(self.lottieView)
        self.view.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblDescription.text = ""
    }
    func animationLoading() {
        DispatchQueue.main.async {
            self.view.isHidden = false
            self.parent?.view.bringSubviewToFront(self.view)
            self.lottieView.loopAnimation = true
            self.lottieView.play(fromFrame: 0, toFrame: 120, withCompletion: nil)
        }
    }
    func animationFinishCorrect(correctDescription : String = "") {
        DispatchQueue.main.async {
            self.view.isHidden = false
            self.lblDescription.textColor = .white
            self.lblDescription.text = correctDescription
            if self.lottieView.isAnimationPlaying {
                self.lottieView.loopAnimation = false
                self.lottieView.completionBlock = { (result: Bool) in ()
                self.lottieView.play(fromFrame: 238, toFrame: 418, withCompletion:
                            {[weak self] (complete: Bool) in
                                self!.view.isHidden = true
                        })
                }
            } else {
                self.lottieView.play(fromFrame: 238, toFrame: 418, withCompletion:
                        {[weak self] (complete: Bool) in
                            self!.view.isHidden = true
                })
            }
        }
    }
    func animationFinishError(errorDescription : String = "") {
        DispatchQueue.main.async {
            self.view.isHidden = false
            self.lblDescription.textColor = .red
            self.lblDescription.text = errorDescription
            if self.lottieView.isAnimationPlaying {
                self.lottieView.loopAnimation = false
                self.lottieView.completionBlock = { (result: Bool) in ()
                    self.lottieView.play(fromFrame: 655, toFrame: 850, withCompletion:
                            {[weak self] (complete: Bool) in self!.finishWithError() })
                }
            } else {
                self.lottieView.play(fromFrame: 655, toFrame: 850, withCompletion:
                    {[weak self] (complete: Bool) in self!.finishWithError() })
            }
        }
    }
    func finishWithError() {
        self.lblDescription.text = ""
        self.view.isHidden = true
    }
}
