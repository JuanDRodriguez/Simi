//
//  ChoiceCell.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class ChoiceCell: UITableViewCell {
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    var option : [String: Any] = [:]
    var optionChanging : (([String: Any], Bool) -> Void)?
    var lottieView = LOTAnimationView(name: "check")
    var lottieInit = false
    var index: Int!
    func initLottie (){
        self.lottieInit = true
        let width = self.btnSelect.frame.width
        self.lottieView.isUserInteractionEnabled = false
        self.lottieView.frame = CGRect(x: 0.0, y: 0.0, width: width * 1.7, height: width * 1.7)
        self.lottieView.center = CGPoint(x: self.btnSelect.bounds.width / 2.0, y: self.btnSelect.bounds.height / 2.0)
        self.btnSelect.addSubview(lottieView)
    }
    override func updateConstraints() {
        super.updateConstraints()
        self.lottieView.center = CGPoint(x: self.btnSelect.bounds.width / 2.0, y: self.btnSelect.bounds.height / 2.0)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if !self.lottieInit {
            self.initLottie()
        }
        self.lottieView.center = CGPoint(x: self.btnSelect.bounds.width / 2.0, y: self.btnSelect.bounds.height / 2.0)
    }
    func setOption(option: [String: Any], optionChanging : @escaping ([String: Any], Bool) -> Void) {
        self.optionChanging = optionChanging
        self.option = option
        if let name = option[KeysOptionQuestion.option.rawValue] as? String {
            self.lblQuestion.text = name
        }
        guard let selected =  option[KeysOptionQuestion.selected.rawValue] as? Bool else { return }
        if selected {
            self.lottieView.setProgressWithFrame(21)
        } else {
            self.lottieView.setProgressWithFrame(0)
        }
        self.lottieView.center = CGPoint(x: self.btnSelect.bounds.width / 2.0, y: self.btnSelect.bounds.height / 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.lottieView.center = CGPoint(x: self.btnSelect.bounds.width / 2.0, y: self.btnSelect.bounds.height / 2.0)
            

        }
    }
    @IBAction func changeOption(_ sender: Any) {
        if let selected = self.option[KeysOptionQuestion.selected.rawValue] as? Bool{
            if selected {
                Utils.runAnimation(lottieAnimation: self.lottieView, from: 21, to: 0)
            } else {
                if CurrentSupervision.shared.isEditingOnLimit() {
                    if let weighing = self.option[KeysOptionQuestion.weighing.rawValue] as? Int {
                        if weighing < 0 {
                            NotificationCenter.default.post(name: .tryingAddBreaches, object: nil)
                            print("SELECCIONANDO!!!!!!!!!! \(self.option[KeysOptionQuestion.weighing.rawValue])")
                            Utils.index = self.index
                            return
                        }
                    }
                } else {
                    Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 21)
                }
            }
            self.option[KeysOptionQuestion.selected.rawValue] = !selected
            if let optionC = self.optionChanging {
                optionC(self.option, !selected)
            }
        }
    }
}
