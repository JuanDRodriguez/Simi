//
//  BreachCell.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class BreachCell: UITableViewCell {
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewActiveBreach: UIView!
    @IBOutlet weak var viewLevelBreach: UIView!
    @IBOutlet weak var viewDateBreach: UIView!
    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var widthLevelBreachConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAlert: UIView!
    var lottieViewAction = LOTAnimationView(name: "breach")
    var lottieViewAlert = LOTAnimationView(name: "alarma")
    var breachCell : [String: Any] = [:]
    var updateBreach : (([String: Any]) -> Void)?
    var question : [String: Any] = [:]
    
    @IBOutlet weak var btnBreachLevel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnAlert.imageView?.contentMode = .scaleAspectFit
        self.lottieViewAction.alpha = 0.5
        self.lottieViewAction.loopAnimation = true
        self.lottieViewAction.animationSpeed = 0.4
        self.lottieViewAction.isUserInteractionEnabled = false
        let width = self.viewActiveBreach.frame.width * 1.2
        self.lottieViewAction.frame = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        self.lottieViewAction.center = CGPoint(x: self.viewActiveBreach.frame.width / 2.0, y: self.viewActiveBreach.frame.height / 2.0)
        self.viewActiveBreach.addSubview(self.lottieViewAction)
        
        self.lottieViewAlert.animationSpeed = 1.5
        self.lottieViewAlert.isUserInteractionEnabled = false
        let widthAlert = self.viewAlert.frame.height * 1.5
        self.lottieViewAlert.frame = CGRect(x: 0.0, y: 0.0, width: widthAlert, height: widthAlert)
        self.lottieViewAlert.center = CGPoint(x: self.btnAlert.frame.width / 2.0, y: self.btnAlert.frame.height / 2.0)
        self.viewAlert.addSubview(self.lottieViewAlert)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setBreach (dateSolution: Bool, breachLevel: Bool, breach: [String: Any], question: [String: Any], updateBreach : @escaping ([String: Any]) -> Void) {
        self.updateBreach = updateBreach
        self.question = question
        self.breachCell = breach
        self.viewDateBreach.isHidden = !dateSolution
        if self.viewDateBreach.isHidden {
            self.widthDateConstraint.constant = 0
            
        } else {
           
            self.widthDateConstraint.constant = 85
        }
        
        
        if breachLevel{
            self.viewLevelBreach.isHidden = false
        }
        else{
            self.viewLevelBreach.isHidden = true
        }
       
        
        
        
        if self.viewLevelBreach.isHidden {
            self.widthLevelBreachConstraint.constant = 0
        } else {
            self.widthLevelBreachConstraint.constant = 45
        }
        self.lblTitle.text = breach[KeysBreachOption.description.rawValue] as? String ?? ""
        if let selected = breach[KeysBreachOption.isSelected.rawValue] as? Bool{
            if selected {
                self.lottieViewAction.play()
                self.lottieViewAction.alpha = 1
                self.checkDate()
            } else {
                self.lottieViewAction.stop()
                self.lottieViewAction.alpha = 0.5
            }
        }
        btnBreachLevel.titleLabel?.minimumScaleFactor = 0.5
        btnBreachLevel.titleLabel?.numberOfLines = 3
        btnBreachLevel.titleLabel?.textAlignment = .center
        btnBreachLevel.titleLabel?.adjustsFontSizeToFitWidth = true
        if let levelBreach = self.breachCell[KeysBreachOption.levelBreach.rawValue] as? String {
            self.btnBreachLevel.setTitle(levelBreach, for: .normal)
        } else  {
            self.btnBreachLevel.setTitle("--", for: .normal)
        }
        if let dateBreach = self.breachCell[KeysBreachOption.dateSolution.rawValue] as? Date {
           self.btnDate.setTitle(Utils.stringFromDate(date: dateBreach), for: .normal)
        }
    }
    func checkDate(){
        if (self.breachCell[KeysBreachOption.dateSolution.rawValue] as? Date) == nil {
            if !self.viewDateBreach.isHidden {
                self.showDate(0)
            }
        }
    }
    @IBAction func showDate(_ sender: Any) {
        NotificationCenter.default.post(name: .showDatePickerBereach, object: self.breachCell)
    }
    @IBAction func changeLevelBreach(_ sender: Any) {
      
    }
    @IBAction func addAlert(_ sender: Any) {
        let currentSupervision = CurrentSupervision.shared.getCurrentUnit()
        let currentModule = CurrentSupervision.shared.getCurrentModule()
        guard let titleBtnDate = self.btnDate.title(for: .normal) else {return}
        guard let topic = self.question[KeysQuestion.topic.rawValue] as? String else {return}
        guard let question = self.question[KeysQuestion.question.rawValue] as? String else {return}
        guard let module = currentModule[KeysModule.name.rawValue] as? String else {return}
        guard let unitName = currentSupervision[KeysQr.nameUnit.rawValue] as? String else {
            return
        }
        guard let keyUnit = currentSupervision[KeysQr.keyUnit.rawValue] as? String else {
            return
        }
        if let date = Utils.dateFromString(stringDate: titleBtnDate) {
            Utils.addReminder(dateAlert: date, title: "\(keyUnit)-\(unitName)", description: "\(module) - \(topic) : \(question)"){[unowned self](granted, error) in
                if granted && error  == nil {
                    Utils.runAnimation(lottieAnimation: self.lottieViewAlert, from: 0, to: 60)
                }
            }
        }
    }
}
