//
//  EmojiQuestionView.swift
//  Supervisores
//
//  Created by Sharepoint on 11/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class EmojiQuestionView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnChoice1: UIButton!
    @IBOutlet weak var btnChoice2: UIButton!
    @IBOutlet weak var bntChoice3: UIButton!
    @IBOutlet weak var btnChoice4: UIButton!
    @IBOutlet weak var stackEmojis: UIStackView!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var viewBreachReason: UIView!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblLegend: UILabel!
    @IBOutlet weak var bottomLegendConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTxtComment: NSLayoutConstraint!
    @IBOutlet weak var heightCommentConstraint: NSLayoutConstraint!
    var delegate: ProtocolBreanch?
    var hasBreach: Bool = false
    var hiddenViews : [UIView]! = []
    var breachReason : BreachReasonProtocol?
    var breachReasonButton : BreachReasonButton?
    let breachReasonFactory = BreachReasonFactory()
    var questionAnswered = false
    var questionChanged = QuestionChanged.noChange
    let lottieEmoji1 = LOTAnimationView(name: "emoji-enojado")
    let lottieEmoji2 = LOTAnimationView(name: "emoji-maomeno")
    let lottieEmoji3 = LOTAnimationView(name: "emoji-feliz")
    let lottieEmoji4 = LOTAnimationView(name: "emoji-muy-feliz")
    var question : [String: Any]
    var nibView: UIView!
    var isEditingSupervision: Bool = false
    var questionSize: CGFloat = 0.0
    var updateContrains = false
    var lottieCreated = false
    var isSelectedCell = false
    var emojiSelected = 0
    var options : [[String: Any]]?
    var optionBreach : [String: Any]?
    var questionLoaded = false
    var isFullMode = false
    var reachedReasonsComplete = false
    var vc: UIViewController!
    init(selected: Bool, question:[String: Any], frame: CGRect, isEditingSupervision: Bool) {
        self.isEditingSupervision = isEditingSupervision
        self.question = question
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.nibView = Bundle.main.loadNibNamed("EmojiQuestionView", owner: self, options: nil)![0] as! EmojiQuestionView
        self.nibView .frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(self.nibView)
        self.layoutIfNeeded()
        self.updateContrains = true
        self.viewBreachReason.isHidden = true
        self.checkTitles()
        self.checkComment()
    }
    override func updateConstraints() {
        super.updateConstraints()
        if updateContrains && !lottieCreated {
            if let _ = self.btnChoice1 {
                self.loadLottieAnimation()
            }
            self.questionLoaded = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        self.question = [:]
        super.init(coder: aDecoder)
    }
    func loadLottieAnimation() {
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
        self.breachReasonButton = BreachReasonButton(frame: self.viewBreachReason.bounds){
            [unowned self] in
            self.openBreachReasons()
        }
        self.viewBreachReason.addSubview(self.breachReasonButton!)
        self.checkOptions()
        if let breachComplete = self.question[KeysQuestion.breachEnded.rawValue] as? Bool {
            if breachComplete {
                self.formComplete(complete: breachComplete, moveView : false)
            }
        }
    }
    func checkOptions(){
        if var options = question[KeysQuestion.options.rawValue] as? [[String: Any]] {
            options = options.sorted(by: {
                guard let idOption1 = $0[KeysOptionQuestion.id.rawValue] as? Int else {return true}
                guard let idOption2 = $1[KeysOptionQuestion.id.rawValue] as? Int else {return false}
                return idOption1 < idOption2
            })
            self.options = options
            for (i, option) in options.enumerated() {
                if let lbl = stackEmojis.viewWithTag(i + 1) as? UILabel{
                    lbl.text = option[KeysOptionQuestion.option.rawValue] as? String ?? ""
                }
                if let selected = option[KeysOptionQuestion.selected.rawValue] as? Bool {
                    if selected {
                        self.updateEmoji(newEmoji: i + 1)
                    }
                }
            }
        }
    }
    func disableQuestion() {
        for view in self.stackEmojis.subviews {
            view.alpha = 0.5
            view.isUserInteractionEnabled = false
        }
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
        guard let questionID = self.question[KeysQuestion.id.rawValue] as? Int else {return}
        self.hasBreach = false
        self.questionAnswered = true
        NotificationCenter.default.post(name: .updateQuestionAswered, object: true)
        if let optionsSelected = self.options {
            if newEmoji - 1 < optionsSelected.count {
                let optionSelected = optionsSelected[newEmoji - 1]
                if let breach = optionSelected[KeysOptionQuestion.breach.rawValue] as? Bool{
                    self.viewBreachReason.isHidden = !breach
                    if breach {
                        
                        if self.isEditingSupervision && CurrentSupervision.shared.isEditingOnLimit() {
                            self.viewBreachReason.isHidden  = true
                            NotificationCenter.default.post(name: .tryingAddBreaches, object: nil)
                            return
                        }
                        
                        
                        self.questionChanged = .changeToBreach
                        self.optionBreach = optionSelected
                        self.hiddeComments()
                        self.hasBreach = true
                        if !self.questionLoaded {
                            self.disableQuestion()
                        }
                    } else {
                        self.questionChanged = .changeToOk
                        self.showComments()
                    }
                }
                if let idSelected = optionSelected[KeysOptionQuestion.id.rawValue] as? Int {
                    QuestionViewModel.shared.optionSelected(idQuestion: questionID, idOption: idSelected, selected: true)
                }
                if self.emojiSelected > 0 {
                    let pastOption = optionsSelected[self.emojiSelected - 1]
                    if let idPast = pastOption[KeysOptionQuestion.id.rawValue] as? Int {
                        QuestionViewModel.shared.optionSelected(idQuestion: questionID, idOption: idPast, selected: false)
                    }
                }
            }
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
        }
        self.updateQuestion()
    }
    func updateQuestion(){
        if let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int {
            if let q = QuestionViewModel.shared.getQuestionBy(id: idQuestion){
                self.question = q
            }
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
