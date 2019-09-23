//
//  BinaryQuestionView.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class BinaryQuestionView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var lblTxtQuestion: UILabel!
    @IBOutlet weak var viewAnimation: UIButton!
    @IBOutlet weak var viewBreachReason: UIView!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblLegend: UILabel!
    @IBOutlet weak var bottomLegendConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTxtComment: NSLayoutConstraint!
    @IBOutlet weak var heightCommentConstraint: NSLayoutConstraint!

    var isEditingSupervision: Bool = false
    var question : [String: Any]
    var hasBreach: Bool = false
    var optionBreach : [String: Any]?
    var optionOk : [String: Any]?
    var delegate: ProtocolBreanch?
    var optionCorrect : [String: Any]?
    var hiddenViews : [UIView]! = []
    var breachReason : BreachReasonProtocol?
    var breachReasonButton : BreachReasonButton?
    var lottieView = LOTAnimationView(name: "switch")
    var breachReasonFactory = BreachReasonFactory()
    var questionAnswered = true
    var selectOk = true
    var isSelectedCell = false
    var updateContrains = false
    var lottieCreated = false
    var isFullMode = false
    var reachedReasonsComplete = false
    var questionChanged = QuestionChanged.noChange
    var questionSize: CGFloat = 0.0
    var nibView: UIView!
    var questionLoaded = false
    var vc: UIViewController!
    init(selected: Bool, question:[String: Any], frame: CGRect, isEditingSupervision: Bool) {
        self.isEditingSupervision = isEditingSupervision
        var opt : [[String : Any]] = []
        if var options = question[KeysQuestion.options.rawValue] as? [[String: Any]] {
            if options.count >= 2 {
                if  let weighing1 = options[0][KeysOptionQuestion.weighing.rawValue] as? Int {
                    if weighing1 > 0 {
                        self.optionBreach = options[1]
                        self.optionOk = options[0]
                        options[0][KeysOptionQuestion.selected.rawValue] = true
                        if let idQ = question[KeysQuestion.id.rawValue] as? Int {
                            if let idOpt = options[0][KeysOptionQuestion.id.rawValue] as? Int {
                                QuestionViewModel.shared.optionSelected(idQuestion: idQ, idOption: idOpt, selected: true)
                            }
                        }
                    } else {
                        self.optionBreach = options[0]
                        self.optionOk = options[1]
                        options[1][KeysOptionQuestion.selected.rawValue] = true
                        if let idQ = question[KeysQuestion.id.rawValue] as? Int {
                            if let idOpt = options[1][KeysOptionQuestion.id.rawValue] as? Int {
                                QuestionViewModel.shared.optionSelected(idQuestion: idQ, idOption: idOpt, selected: true)
                            }
                        }
                    }
                }
            }
            opt = options
        }
        self.question = question
        self.question[KeysQuestion.options.rawValue] = opt
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.nibView = Bundle.main.loadNibNamed("BinaryQuestionView", owner: self, options: nil)![0] as! BinaryQuestionView
        self.nibView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(self.nibView)
        self.lblTxtQuestion.text = self.optionOk?[KeysOptionQuestion.option.rawValue] as? String ?? "Cumple"
        self.checkTitles()
        self.checkComment()
        self.layoutIfNeeded()
        self.updateContrains = true
        self.viewBreachReason.isHidden = self.selectOk
        if let optionB = self.optionBreach {
            if let selected = optionB[KeysOptionQuestion.selected.rawValue] as? Bool{
                if selected {
                    if isEditingSupervision {
                        if let weighing = optionB[KeysOptionQuestion.weighing.rawValue] as? Int {
                            if weighing <= 0 {
                                self.disableQuestion()
                            }
                        } else  {
                            self.disableQuestion()
                        }
                    }
                    self.changeOption(1)
                }
            }
        }
        self.questionLoaded = true
    }
    func disableQuestion() {
        self.viewAnimation.alpha = 0.5
        self.viewAnimation.isUserInteractionEnabled = false
        self.lblTxtQuestion.alpha = 0.5
    }
    override func updateConstraints() {
        super.updateConstraints()
        if updateContrains && !lottieCreated {
            if let _ = self.viewAnimation {
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
        self.viewAnimation.layer.masksToBounds = true
        self.lottieView.animationSpeed = 2
        self.lottieView.isUserInteractionEnabled = false
        let width = self.viewAnimation.frame.width
        self.lottieView.frame = CGRect(x: 0.0, y: 0.0, width: width * 2.0, height: width * 2.0)
        self.lottieView.center = CGPoint(x: self.viewAnimation.frame.width / 2.0, y: self.viewAnimation.frame.height / 2.0)
        self.lottieView.setProgressWithFrame(45)
        self.viewAnimation.addSubview(self.lottieView)
        self.breachReasonButton = BreachReasonButton(frame: self.viewBreachReason.bounds) {
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
    @IBAction func changeOption(_ sender: Any) {
        if self.isEditingSupervision && CurrentSupervision.shared.isEditingOnLimit() {
            if selectOk {
                NotificationCenter.default.post(name: .tryingAddBreaches, object: nil)
                return
            }
        }
        self.selectOk = !self.selectOk
        self.viewBreachReason.isHidden = self.selectOk
        
        if self.selectOk {
            self.lblTxtQuestion.text = self.optionOk?[KeysOptionQuestion.option.rawValue] as? String ?? "Cumple"
            Utils.runAnimation(lottieAnimation: self.lottieView, from: 0, to: 45)
            self.showComments()
            self.hasBreach = false
            if let idOption = self.optionOk?[KeysOptionQuestion.id.rawValue] as? Int {
                self.updateOptionSelected(selected: true, idOption: idOption)
            }
            if let idOption = self.optionBreach?[KeysOptionQuestion.id.rawValue] as? Int {
                self.updateOptionSelected(selected: false, idOption: idOption)
            }
            if self.questionLoaded {
                self.questionChanged = .changeToOk
            }
        } else {
            if self.questionLoaded {
                self.questionChanged = .changeToBreach
            } else {
                self.question[KeysQuestion.breachEnded.rawValue] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.breachReasonButton?.setBreachReasonfinish(finished: true)
                    self.delegate?.updateBreach()
                }
                self.breachReasonButton = BreachReasonButton(frame: self.viewBreachReason.bounds) {
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
            self.hasBreach = true
            self.hiddeComments()
            self.lblTxtQuestion.text = self.optionBreach?[KeysOptionQuestion.option.rawValue] as? String ?? "No cumple"
            Utils.runAnimation(lottieAnimation: self.lottieView, from: 45, to: 90)
            if let idOption = self.optionBreach?[KeysOptionQuestion.id.rawValue] as? Int {
                self.updateOptionSelected(selected: true, idOption: idOption)
            }
            if let idOption = self.optionOk?[KeysOptionQuestion.id.rawValue] as? Int {
                self.updateOptionSelected(selected: false, idOption: idOption)
            }
        }
        if let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int {
            if let q = QuestionViewModel.shared.getQuestionBy(id: idQuestion){
                self.question = q
            }
        }
    }
}
