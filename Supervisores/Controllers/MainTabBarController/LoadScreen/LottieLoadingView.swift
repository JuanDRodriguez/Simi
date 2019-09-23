//
//  LottieLoadingView.swift
//  Supervisores
//
//  Created by Sharepoint on 22/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

//import Foundation
//import UIKit
//import Lottie
//
//struct ExtensionLottie {
//    static var view : String = "UIView"
//    static var animationView: String = "AnimationView"
//}
//
//extension UIViewController {
////    private struct Holder {
////        var _lottieView = UIView()
////        var _animationView = LOTAnimationView(name: "loader")
////    }
////    var lottieView:UIView {
////        get { return Holder._lottieView }
////        set(newValue) { Holder._lottieView = newValue }
////    }
////    
////    var animationView:LOTAnimationView {
////        get { return Holder._animationView }
////        set(newValue) { Holder._animationView = newValue }
////    }
////    
////    func updateLottieConstrains(){
////        DispatchQueue.main.async {
////            self.lottieView?.frame = self.view.bounds
////            self.animationView.center = self.view.center
////        }
////    }
////    
////    func addLottieView(){
////        self.lottieView = UIView()
////        if let lottieView = self.lottieView {
////            lottieView.frame = self.view.bounds
////            self.view.addSubview(lottieView)
////            lottieView.addSubview(self.animationView)
////            self.animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
////            self.animationView.center = self.view.center
////            lottieView.isHidden = true
////            lottieView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
////            self.animationView.animationSpeed = 2
////        }
////    }
////    
////    func animationLoading(){
////        DispatchQueue.main.async {
////            
////            
////            if let lottieV = self.lottieView {
////                lottieV.isHidden = false
////                self.view.bringSubviewToFront(lottieV)
////                self.animationView.loopAnimation = true
////                self.animationView.play(fromFrame: 0, toFrame: 120, withCompletion: nil)
////            }
////        }
////    }
////    
////    func animationFinishCorrect(){
////        DispatchQueue.main.async {
////            if let lottieV = self.lottieView {
////                lottieV.isHidden = false
////                self.view.bringSubviewToFront(lottieV)
////                if self.animationView.isAnimationPlaying {
////                    self.animationView.loopAnimation = false
////                    self.animationView.completionBlock = { (result: Bool) in ()
////                        self.animationView.play(fromFrame: 238, toFrame: 418, withCompletion:
////                            {[weak self] (complete: Bool) in
////                                self!.lottieView?.isHidden = true
////                                
////                        })
////                    }
////                } else {
////                    self.animationView.play(fromFrame: 238, toFrame: 418, withCompletion:
////                        {[weak self] (complete: Bool) in
////                            self!.lottieView?.isHidden = true
////                    })
////                }
////            }
////        }
////    }
////    
////    func animationFinishError(){
////        DispatchQueue.main.async {
////            
////            print("ERROR LOTTIE")
////            if let lottieV = self.lottieView {
////                lottieV.isHidden = false
////                self.view.bringSubviewToFront(lottieV)
////                if self.animationView.isAnimationPlaying {
////                    self.animationView.loopAnimation = false
////                    self.animationView.completionBlock = { (result: Bool) in ()
////                        self.animationView.play(fromFrame: 655, toFrame: 850, withCompletion:
////                            {[weak self] (complete: Bool) in self!.finishWithError() })
////                    }
////                } else {
////                    self.animationView.play(fromFrame: 655, toFrame: 850, withCompletion:
////                        {[weak self] (complete: Bool) in self!.finishWithError() })
////                }
////            }
////        }
////    }
////    
////    func finishWithError(){
////        if let lottieV = self.lottieView {
////            lottieV.isHidden = true
////        }
////    }
//}
