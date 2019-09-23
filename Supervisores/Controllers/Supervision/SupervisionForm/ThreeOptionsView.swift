//
//  ThreeOptionsView.swift
//  Supervisores
//
//  Created by Sharepoint on 11/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class ThreeOptionsView: UIView {
    
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblLegend: UILabel!
    @IBOutlet weak var bottomLegendConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOk: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblNotOk: UILabel!
    @IBOutlet weak var btnNotOk: UIButton!
    @IBOutlet weak var lblDontApply: UILabel!
    @IBOutlet weak var btnDontApply: UIButton!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var viewBreachReason: UIView!
    @IBOutlet weak var bottomTxtComment: NSLayoutConstraint!
    
    @IBOutlet weak var heightCommentConstraint: NSLayoutConstraint!
    var isEditingSupervision: Bool = false
    var hasBreach: Bool = false
    var hiddenViews : [UIView]! = []
    var question : [String: Any]
    var optionBreach : [String: Any]?
    var optionOk : [String: Any]?
    var optionDontApply : [String: Any]?
    var questionChanged = QuestionChanged.noChange
    var breachReason : BreachReasonProtocol?
    var breachReasonButton : BreachReasonButton?
    let breachReasonFactory = BreachReasonFactory()
    var questionSize: CGFloat = 0.0
    var lottieViewOk = LOTAnimationView(name: "switch")
    var lottieViewNotOk = LOTAnimationView(name: "switch")
    var lottieViewDontApply = LOTAnimationView(name: "switch")
    var questionAnswered = true
    var optionSelected = 0
    var nibView: UIView!
    var updateContrains = false
    var lottieCreated = false
    var delegate: ProtocolBreanch!
    var isFullMode = false
    var reachedReasonsComplete = false
    var questionLoaded = true
    var vc: UIViewController!
    var isSelectedCell = false    
    init(selected: Bool, question:[String: Any], frame: CGRect, isEditingSupervision: Bool) {
        self.isEditingSupervision = isEditingSupervision
        self.question = question
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.nibView  = Bundle.main.loadNibNamed("ThreeOptionsView", owner: self, options: nil)![0] as! ThreeOptionsView
        self.nibView .frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.checkTitles()
        self.checkComment()
        self.addSubview(self.nibView )
        self.layoutIfNeeded()
        self.updateContrains = true
        self.viewBreachReason.isHidden = true
        
        guard let options = self.question[KeysQuestion.options.rawValue] as? [[String: Any]] else { return }
        var selectedOne = false
        for option in options {
            if let weight = option[KeysOptionQuestion.weighing.rawValue] as? Int{
                if weight > 0 {
                    self.optionOk = option
                    self.lblOk.text = option[KeysOptionQuestion.option.rawValue] as? String ?? ""
                    if let selected = option[KeysOptionQuestion.selected.rawValue] as? Bool{
                        if selected {
                            self.chooseOk(1)
                            selectedOne = true
                        }
                    }
                } else {
                    if let breach = option[KeysOptionQuestion.breach.rawValue] as? Bool {
                        if breach {
                            self.optionBreach = option
                            self.lblNotOk.text = option[KeysOptionQuestion.option.rawValue] as? String ?? ""
                            if let selected = option[KeysOptionQuestion.selected.rawValue] as? Bool{
                                if selected {
                                    self.chooseNotOk(2)
                                    selectedOne = true
                                }
                            }
                            if isEditingSupervision {
                                self.disableQuestion()
                            }
                        } else {
                            self.optionDontApply = option
                            self.lblDontApply.text = option[KeysOptionQuestion.option.rawValue] as? String ?? ""
                            if let selected = option[KeysOptionQuestion.selected.rawValue] as? Bool{
                                if selected {
                                    self.chooseDontApply(3)
                                    selectedOne = true
                                }
                            }
                        }
                    }
                }
            }
        }
        if !selectedOne {
            if let optionOk = self.optionOk {
                if let idQ = question[KeysQuestion.id.rawValue] as? Int {
                    if let idOpt = optionOk[KeysOptionQuestion.id.rawValue] as? Int {
                        QuestionViewModel.shared.optionSelected(idQuestion: idQ, idOption: idOpt, selected: true)
                    }
                }
            }
        }
        self.questionLoaded = true
    }
    func disableQuestion() {
        self.lblOk.alpha = 0.5
        self.lblNotOk.alpha = 0.5
        self.lblDontApply.alpha = 0.5
        self.btnOk.alpha = 0.5
        self.btnOk.isUserInteractionEnabled = false
        self.btnNotOk.alpha = 0.5
        self.btnNotOk.isUserInteractionEnabled = false
        self.btnDontApply.alpha = 0.5
        self.btnDontApply.isUserInteractionEnabled = false
    }
    override func updateConstraints() {
        super.updateConstraints()
        if updateContrains && !lottieCreated {
            if let _ = self.btnOk {
                self.loadLottieAnimation()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.question = [:]
        super.init(coder: aDecoder)
    }
    
    func loadLottieAnimation() {
        self.lottieCreated = true
        self.prepareAnimation(btn: self.btnOk, lottie: self.lottieViewOk)
        self.prepareAnimation(btn: self.btnNotOk, lottie: self.lottieViewNotOk)
        self.prepareAnimation(btn: self.btnDontApply, lottie: self.lottieViewDontApply)
        self.lottieViewOk.setProgressWithFrame(45)
        self.breachReasonButton = BreachReasonButton(frame: self.viewBreachReason.bounds){
            [unowned self] in
            self.openBreachReasons()
        }
        self.viewBreachReason.addSubview(self.breachReasonButton!)
        if let breachComplete = self.question[KeysQuestion.breachEnded.rawValue] as? Bool {
            if breachComplete {
                self.formComplete(complete: breachComplete, moveView : false)
            }
        }
    }
    
    func prepareAnimation(btn: UIButton, lottie: LOTAnimationView) {
        let width = btn.frame.width
        btn.layer.masksToBounds = true
        lottie.animationSpeed = 2
        lottie.isUserInteractionEnabled = false
        lottie.frame = CGRect(x: 0.0, y: 0.0, width: width * 2.0, height: width * 2.0)
        lottie.center = CGPoint(x: btn.frame.width / 2.0, y: btn.frame.height / 2.0)
        btn.addSubview(lottie)
    }
    
    @IBAction func chooseOk(_ sender: Any) {
        if self.questionLoaded {
            self.questionChanged = .changeToOk
        }
        self.hasBreach = false
        if self.optionSelected == 1 {
            Utils.runAnimation(lottieAnimation: self.lottieViewNotOk, from: 45, to: 90)
        }
        if self.optionSelected == 2 {
            Utils.runAnimation(lottieAnimation: self.lottieViewDontApply, from: 45, to: 90)
        }
        if self.optionSelected != 0 {
            Utils.runAnimation(lottieAnimation: self.lottieViewOk, from: 0, to: 45)
        }
        self.optionSelected = 0
        self.viewBreachReason.isHidden = true
        self.showComments()
        guard let idOk = self.optionOk?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard let idBreach = self.optionBreach?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard let idDontApply = self.optionDontApply?[KeysOptionQuestion.id.rawValue] as? Int else {return}

        self.updateOptionSelected(selected: true, idOption: idOk)
        self.updateOptionSelected(selected: false, idOption: idBreach)
        self.updateOptionSelected(selected: false, idOption: idDontApply)
        self.updateQuestion()
    }
    func updateQuestion(){
        if let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int {
            if let q = QuestionViewModel.shared.getQuestionBy(id: idQuestion){
                self.question = q
            }
        }
    }
    @IBAction func chooseNotOk(_ sender: Any) {
        if self.isEditingSupervision && CurrentSupervision.shared.isEditingOnLimit() {
            NotificationCenter.default.post(name: .tryingAddBreaches, object: nil)
            return
        }
        if self.questionLoaded {
            self.questionChanged = .changeToBreach
        }
        self.hasBreach = true
        if self.optionSelected == 0 {
            Utils.runAnimation(lottieAnimation: self.lottieViewOk, from: 45, to: 90)
        }
        if self.optionSelected == 2 {
             Utils.runAnimation(lottieAnimation: self.lottieViewDontApply, from: 45, to: 90)
        }
        if self.optionSelected != 1 {
            Utils.runAnimation(lottieAnimation: self.lottieViewNotOk, from: 0, to: 45)
        }
        self.optionSelected = 1
        self.viewBreachReason.isHidden = false
        self.hiddeComments()
        guard let idOk = self.optionOk?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard let idBreach = self.optionBreach?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard let idDontApply = self.optionDontApply?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        
        self.updateOptionSelected(selected: false, idOption: idOk)
        self.updateOptionSelected(selected: true, idOption: idBreach)
        self.updateOptionSelected(selected: false, idOption: idDontApply)
        self.updateQuestion()
    }
    
    @IBAction func chooseDontApply(_ sender: Any) {
        if self.questionLoaded {
            self.questionChanged = .changeToOk
        }
        self.hasBreach = false
        if self.optionSelected == 0 {
            Utils.runAnimation(lottieAnimation: self.lottieViewOk, from: 45, to: 90)
        }
        if self.optionSelected == 1 {
            Utils.runAnimation(lottieAnimation: self.lottieViewNotOk, from: 45, to: 90)
        }
        if self.optionSelected != 2 {
            Utils.runAnimation(lottieAnimation: self.lottieViewDontApply, from: 0, to: 45)
        }
        self.optionSelected = 2
        self.viewBreachReason.isHidden = true
        self.showComments()
        guard let idOk = self.optionOk?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard let idBreach = self.optionBreach?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        guard let idDontApply = self.optionDontApply?[KeysOptionQuestion.id.rawValue] as? Int else {return}
        
        self.updateOptionSelected(selected: false, idOption: idOk)
        self.updateOptionSelected(selected: false, idOption: idBreach)
        self.updateOptionSelected(selected: true, idOption: idDontApply)
        self.updateQuestion()
    }
}
