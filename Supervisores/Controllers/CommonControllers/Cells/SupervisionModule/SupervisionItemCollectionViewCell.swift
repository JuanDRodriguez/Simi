//
//  SupervisionItemCollectionViewCell.swift
//  Supervisores
//
//  Created by Sharepoint on 05/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class SupervisionItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var borderModule: UIImageView!
    @IBOutlet weak var imageModule: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContetn: UIView!
    var lottieView = LOTAnimationView(name: "sectionFill")
    var updateContrains = false
    var lottieCreated = false
    var percent = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        if !lottieCreated {
            self.loadLottieAnimation()
        }
    }

    func loadLottieAnimation() {
        self.lottieView.animationSpeed = 3.0
        self.lottieView.isUserInteractionEnabled = false
        let lottieSize = self.borderModule.frame.width
        self.lottieView.frame = CGRect(x: 0.0, y: 0.0, width: lottieSize, height: lottieSize)
        self.viewContetn.insertSubview(self.lottieView, at: 0)
    }
    
    func setModuleInfo(image: UIImage, title: String, percentFinish: Int) {
        imageModule.image = image
        lblTitle.text = title
        percent = percentFinish
        updatePercent()
    }
    
    func updateCornerRadius(radius: CGFloat) {
        borderModule.layer.cornerRadius = radius / 2.0
        borderModule.layer.borderColor = UIColor.blue.cgColor
        borderModule.layer.borderWidth = 2
        self.lottieView.frame = CGRect(x: 0.0, y: 0.0, width: radius * 1.13, height: radius * 1.13)
        self.lottieView.center = CGPoint(x: radius / 2.0, y: radius / 1.95)
    }
    
    func updatePercent() {
        self.lottieView.stop()
        switch self.percent {
            case 0...5:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 2)
            case 5...10:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 13)
            case 11...20:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 26)
            case 21...30:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 39)
            case 31...40:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 53)
            case 41...50:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 66)
            case 51...60:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 79)
            case 61...70:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 92)
            case 71...80:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 105)
            case 81...90:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 119)
            case 91...99:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 135)
            default:
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 151)
        }
    }
}
