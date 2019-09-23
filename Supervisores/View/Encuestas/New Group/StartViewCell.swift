//
//  StartViewCell.swift
//  Supervisores
//
//  Created by Sharepoint on 9/1/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie
class StartViewCell: BaseView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var starsStack: UIStackView!
    @IBOutlet weak var lblLegend1: UILabel!
    @IBOutlet weak var lblLegend2: UILabel!
    @IBOutlet weak var lblLegend3: UILabel!
    @IBOutlet weak var lblLegend4: UILabel!
    @IBOutlet weak var lblLegend5: UILabel!
    var lottieStars : [LOTAnimationView] = []
    var lottieCreated = false
    var starSelected = 0
    var index: Int!
     var delegate: didSelectOptionEncuesta!
    var options: [OptionQuestion]? = []
    override func awakeFromNib() {
        
    }
    func display(item:[OptionQuestion], title: String)  {
        lblTitle.text = title
        self.options = item
        loadLottieAnimation()
    }
    func loadLottieAnimation() {
        for i in 0 ..< options!.count {
            
        if let lbl = starsStack.viewWithTag(i + 1) as? UILabel{
            lbl.text = options?[i].option
        }
        }
        self.lottieCreated = true
        let sizeLottie = self.star1.frame.width * 2.0
        let centerAnim = CGPoint(x: self.star1.frame.width / 2.0 , y: self.star1.frame.height / 2.0)
        
        for _ in 0..<5 {
            let lottie = LOTAnimationView(name: "star")
            lottie.isUserInteractionEnabled = false
            lottie.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
            self.lottieStars.append(lottie)
        }
        self.star1.addSubview(self.lottieStars[0])
        self.lottieStars[0].center = centerAnim
        self.star2.addSubview(self.lottieStars[1])
        self.lottieStars[1].center = centerAnim
        self.star3.addSubview(self.lottieStars[2])
        self.lottieStars[2].center = centerAnim
        self.star4.addSubview(self.lottieStars[3])
        self.lottieStars[3].center = centerAnim
        self.star5.addSubview(self.lottieStars[4])
        self.lottieStars[4].center = centerAnim
    }
    
    @IBAction func chooseStar1(_ sender: Any) {
        self.updateStarSelected(newStar: 1)
    }
    
    @IBAction func chooseStar2(_ sender: Any) {
        self.updateStarSelected(newStar: 2)
    }
    
    @IBAction func chooseStar3(_ sender: Any) {
        self.updateStarSelected(newStar: 3)
    }
    
    @IBAction func chooseStar4(_ sender: Any) {
        self.updateStarSelected(newStar: 4)
    }
    
    @IBAction func chooseStar5(_ sender: Any) {
        self.updateStarSelected(newStar: 5)
    }
    func disableQuestion() {
        for view in self.starsStack.subviews {
            view.alpha = 0.5
            view.isUserInteractionEnabled = false
        }
    }
    func updateStarSelected(newStar: Int){
       
        if let optionsSelected = self.options {
            if newStar < optionsSelected.count + 1 {
                let optionSelected = optionsSelected[newStar - 1]
                }
            
                if starSelected > 0 {
                    let pastOption = optionsSelected[starSelected - 1]
                    
                
            }
        }
        if self.starSelected > newStar {
            for i in newStar..<self.starSelected {
                Utils.runAnimation(lottieAnimation: self.lottieStars[i], from: 30, to: 0)
            }
        }
        for i in 0..<newStar {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                Utils.runAnimation(lottieAnimation: self.lottieStars[i], from: 0, to: 30)
            })
        }
        self.starSelected = newStar
        delegate.didselectedSingleOption(idResp: [options![newStar - 1].id], index: self.index)
    }


}
