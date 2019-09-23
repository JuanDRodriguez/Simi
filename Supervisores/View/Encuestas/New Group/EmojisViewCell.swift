//
//  EmojisViewCell.swift
//  Supervisores
//
//  Created by Sharepoint on 9/1/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie
class EmojisViewCell: BaseView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnChoice1: UIButton!
    @IBOutlet weak var btnChoice2: UIButton!
    @IBOutlet weak var bntChoice3: UIButton!
    @IBOutlet weak var btnChoice4: UIButton!
    @IBOutlet weak var stackEmojis: UIStackView!
    let lottieEmoji1 = LOTAnimationView(name: "emoji-enojado")
    let lottieEmoji2 = LOTAnimationView(name: "emoji-maomeno")
    let lottieEmoji3 = LOTAnimationView(name: "emoji-feliz")
    let lottieEmoji4 = LOTAnimationView(name: "emoji-muy-feliz")
    var lottieCreated = false
    var emojiSelected = 0
    var index: Int!
     var delegate: didSelectOptionEncuesta!
    var options: [OptionQuestion] = []
    override func awakeFromNib() {
        
    }
    func display(item:[OptionQuestion],title: String)  {
        self.options = item
        lblTitle.text = title
        loadLottieAnimation()
    }
    func loadLottieAnimation() {
        for i in 0 ..< options.count {
            if let lbl = stackEmojis.viewWithTag(i + 1) as? UILabel{
                lbl.text = options[i].option
            }
        }
        self.lottieCreated = true
        let sizeLottie = self.btnChoice1.frame.height
        let centerAnim = CGPoint(x: self.btnChoice1.frame.width / 2.0 , y: self.btnChoice1.frame.height / 2.0)
        
        self.lottieEmoji1.isUserInteractionEnabled = false
        self.lottieEmoji1.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
        self.btnChoice1.addSubview(self.lottieEmoji1)
        self.lottieEmoji1.center = centerAnim
        
        self.lottieEmoji2.isUserInteractionEnabled = false
        self.lottieEmoji2.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
        self.btnChoice2.addSubview(self.lottieEmoji2)
        self.lottieEmoji2.center = centerAnim
        
        self.lottieEmoji3.isUserInteractionEnabled = false
        self.lottieEmoji3.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
        self.bntChoice3.addSubview(self.lottieEmoji3)
        self.lottieEmoji3.center = centerAnim
        
        self.lottieEmoji4.isUserInteractionEnabled = false
        self.lottieEmoji4.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
        self.btnChoice4.addSubview(self.lottieEmoji4)
        self.lottieEmoji4.center = centerAnim
        self.lottieEmoji1.alpha = 0.5
        self.lottieEmoji2.alpha = 0.5
        self.lottieEmoji3.alpha = 0.5
        self.lottieEmoji4.alpha = 0.5
        
        
    }
    @IBAction func chooseOption1(_ sender: Any) {
        self.updateEmoji(newEmoji: 1)
    }
    @IBAction func chooseOption2(_ sender: Any) {
        self.updateEmoji(newEmoji: 2)
    }
    @IBAction func chooseOption3(_ sender: Any) {
        self.updateEmoji(newEmoji: 3)
    }
    @IBAction func chooseOption4(_ sender: Any) {
        self.updateEmoji(newEmoji: 4)
    }
    func updateEmoji(newEmoji: Int){
       
       
        if newEmoji - 1 < options.count {
            let optionSelected = options[newEmoji - 1]

            }
        
        if newEmoji != self.emojiSelected {
            switch self.emojiSelected {
            case 1:
                self.stopAnimation(animation: lottieEmoji1)
            case 2:
                self.stopAnimation(animation: lottieEmoji2)
            case 3:
                self.stopAnimation(animation: lottieEmoji3)
            case 4:
                self.stopAnimation(animation: lottieEmoji4)
            default:
                break
            }
            
            switch newEmoji {
            case 1:
                self.chooseAnimation(animation: self.lottieEmoji1)
            case 2:
                self.chooseAnimation(animation: self.lottieEmoji2)
            case 3:
                self.chooseAnimation(animation: self.lottieEmoji3)
            case 4:
                self.chooseAnimation(animation: self.lottieEmoji4)
            default:
                break
            }
            self.emojiSelected = newEmoji
            delegate.didselectedSingleOption(idResp: [options[newEmoji - 1].id], index: self.index )
            
        }
        
    }
    func stopAnimation(animation: LOTAnimationView){
        animation.stop()
        animation.alpha = 0.5
    }
    
    func chooseAnimation(animation: LOTAnimationView){
        animation.alpha = 1.0
        animation.loopAnimation = true
        Utils.runAnimation(lottieAnimation: animation, from: 0, to: 120)
    }
}
