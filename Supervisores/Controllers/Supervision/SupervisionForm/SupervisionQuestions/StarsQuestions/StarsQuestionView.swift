//
//  StarsQuestionView.swift
//  Supervisores
//
//  Created by Sharepoint on 11/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class StarsQuestionView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var starsStack: UIStackView!
    @IBOutlet weak var viewBreachReason: UIView!
    @IBOutlet weak var bottomTxtComment: NSLayoutConstraint!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblLegend: UILabel!
    @IBOutlet weak var bottomLegendConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightCommentConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLegend1: UILabel!
    @IBOutlet weak var lblLegend2: UILabel!
    @IBOutlet weak var lblLegend3: UILabel!
    @IBOutlet weak var lblLegend4: UILabel!
    @IBOutlet weak var lblLegend5: UILabel!
    
    var questionLoaded = false
    var hasBreach: Bool = false
    var hiddenViews : [UIView]! = []
    var breachReason : BreachReasonProtocol?
    var breachReasonButton : BreachReasonButton?
    let breachReasonFactory = BreachReasonFactory()
    var question : [String: Any]
    var isEditingSupervision: Bool = false
    var delegate: ProtocolBreanch?
    var questionAnswered = false
    var optionBreach : [String: Any]?
    var questionSize: CGFloat = 0.0
    var lottieStars : [LOTAnimationView] = []
    var updateContrains = false
    var lottieCreated = false
    var isSelectedCell = false
    var starSelected = 0
    var nibView: UIView!
    var questionChanged = QuestionChanged.noChange
    var vc: UIViewController!
    var isFullMode = false
    var reachedReasonsComplete = false
    var options : [[String: Any]]?
    
    init(selected: Bool, question:[String: Any], frame: CGRect, isEditingSupervision: Bool) {
        self.isEditingSupervision = isEditingSupervision
        self.question = question
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.nibView = Bundle.main.loadNibNamed("StarsQuestionView", owner: self, options: nil)![0] as! StarsQuestionView
        self.nibView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(self.nibView)
        self.layoutIfNeeded()
        self.updateContrains = true
        self.viewBreachReason.isHidden = true
        self.checkTitles()
        self.checkComment()
        
        if var options = question[KeysQuestion.options.rawValue] as? [[String: Any]] {
            options = options.sorted(by: {
                guard let idOption1 = $0[KeysOptionQuestion.id.rawValue] as? Int else {return true}
                guard let idOption2 = $1[KeysOptionQuestion.id.rawValue] as? Int else {return false}
                return idOption1 < idOption2
            })
            
            self.options = options
            for (i, option) in options.enumerated() {
                if let selected = option[KeysOptionQuestion.selected.rawValue] as? Bool {
                    if selected {
                        self.updateStarSelected(newStar: i + 1)
                    }
                }
                if let lbl = starsStack.viewWithTag(i + 1) as? UILabel{
                    lbl.text = option[KeysOptionQuestion.option.rawValue] as? String ?? ""
                }
            }
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if updateContrains && !lottieCreated {
            if let _ = self.star1 {
                self.loadLottieAnimation()
                self.questionLoaded = true
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        self.question = [:]
        super.init(coder: aDecoder)
    }    
    func loadLottieAnimation() {
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
        self.breachReasonButton = BreachReasonButton(frame: self.viewBreachReason.bounds){
            [unowned self] in
            self.openBreachReasons()
        }
        self.viewBreachReason.addSubview(self.breachReasonButton!)
        if let breachComplete = self.question[KeysQuestion.breachEnded.rawValue] as? Bool {
            if breachComplete {
                self.formComplete(complete: breachComplete, moveView: false)
            }
        }
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
        guard let questionID = self.question[KeysQuestion.id.rawValue] as? Int else {return}
        self.questionAnswered = true
        NotificationCenter.default.post(name: .updateQuestionAswered, object: true)
        self.viewBreachReason.isHidden = true
        self.showComments()
        self.hasBreach = false
        if let optionsSelected = self.options {
            if newStar < optionsSelected.count + 1 {
                let optionSelected = optionsSelected[newStar - 1]
                if let breach = optionSelected[KeysOptionQuestion.breach.rawValue] as? Bool {
                    self.viewBreachReason.isHidden = !breach
                    if breach {
                        
                        if self.isEditingSupervision && CurrentSupervision.shared.isEditingOnLimit() {
                            NotificationCenter.default.post(name: .tryingAddBreaches, object: nil)
                            self.viewBreachReason.isHidden  = true
                            return
                        }
                        
                        self.questionChanged = .changeToBreach
                        self.hasBreach = true
                        self.optionBreach = optionSelected
                        self.hiddeComments()
                        if !self.questionLoaded {
                            self.disableQuestion()
                        }
                    } else {
                        self.questionChanged = .changeToOk
                    }
                }
                if let idSelected = optionSelected[KeysOptionQuestion.id.rawValue] as? Int {
                    QuestionViewModel.shared.optionSelected(idQuestion: questionID, idOption: idSelected, selected: true)
                }
                if starSelected > 0 {
                    let pastOption = optionsSelected[starSelected - 1]
                    if let idPast = pastOption[KeysOptionQuestion.id.rawValue] as? Int {
                        QuestionViewModel.shared.optionSelected(idQuestion: questionID, idOption: idPast, selected: false)
                    }
                }
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
        self.updateQuestion()
    }
    func updateQuestion(){
        if let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int {
            if let q = QuestionViewModel.shared.getQuestionBy(id: idQuestion){
                self.question = q
            }
        }
    }
}
