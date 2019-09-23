//
//  SupervisionListFormViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 11/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

enum QuestionTypes: Int {
    case binary = 1
    case threeOptions = 2
    case multipleChoice = 3
    case emoji = 4
    case stars = 5
    case free = 6
}

protocol SupervisionListDelegate: class {
    func updatePercent(idModule: Int, currentQuestion: Int, percent: Int)
    func dissmisVC()
    func countBreaches(count: Int)
    func newSupervisionFromAddBreaches()
}
protocol  ProtocolBreanch {
    func updateBreach()
}
class SupervisionListFormViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet weak var lblNumberChanges: UILabel!
    
    let MAX_NEW_BREACHES = 5
    
    var lottieView : LottieViewController?
    weak var delegate: SupervisionListDelegate?
    var currentModule: [String: Any] = [:]
    var questionsDicto : [[String: Any]] = []
    var questions : [QuestionProtocol] = []
    var pauseReasons :[[String: Any]] = []
    var currentQuestion = 0
    let spaceQuestion : CGFloat = 55
    var speedAnimation : Double = 0.25
    var blockQuestion = false
    var keyboardShowed = false
    var isShowingPause = false
    var pickerView: PickerSelectView? = nil
    var navBarC : InSupervisionViewController?
    var footerQuestion : FooterQuestionsView?
    var isEditingSupervision: Bool = false
    var isEditingQuestion: Bool = false
    var countNewBreaches = 0
    var titleNavBar: String = "Supervisión"
    var typeStore: String!
    static var vc: UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        self.navBarC = CommonInit.navBArInSupervision(vc: self, navigationBar: self.navBar, title: titleNavBar)
        QuestionViewModel.shared.setListener(listener: self)
        self.lblNumberChanges.layer.cornerRadius = 22
        self.lblNumberChanges.layer.masksToBounds = true
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.questions.count == 0 {
            if let moduleId = self.currentModule[KeysModule.id.rawValue] as? Int {
                if isEditingSupervision == isEditingQuestion{
                let questions = QuestionViewModel.shared.getQuestion(moduleId: moduleId, ovirrideCurrent: false, isEditing: self.isEditingSupervision,type: self.typeStore)
                    if !questions {
                        self.lottieView?.animationLoading()
                    }
                }else{
                     let questions = QuestionViewModel.shared.getQuestion(moduleId: moduleId, ovirrideCurrent: false, isEditing: self.isEditingQuestion,type: self.typeStore)
                    if !questions {
                        self.lottieView?.animationLoading()
                    }
                }
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        if self.pickerView == nil {
            self.pickerView = PickerSelectView(dataPicker: [], frame: self.view.frame)
            self.pickerView?.setTitle(title: "Selecciona un motivo de pausa")
            self.pickerView!.delegate = self
            self.pickerView!.showCancelButton()
        }
        PauseReasonsViewModel.shared.setListener(listener: self)
       
        if self.footerQuestion == nil {
            let width = self.questionsView.frame.width
            let heigth = self.questionsView.frame.height
            let frameFooter = CGRect(x: 0, y: heigth, width: width, height: (self.spaceQuestion  - 10))
            let moduleName = self.currentModule[KeysModule.name.rawValue] as? String
            self.footerQuestion = FooterQuestionsView(frame: frameFooter, module: moduleName ?? "")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblNumberChanges.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(questionAnswered(notification:)), name: .updateQuestionAswered, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBreachReason), name: .showBreachReason, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideBreachReason), name: .hideBreachReason, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPauseReason), name: .showPauseReason, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .hideKeyboard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addBreach), name: .addBreach, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBreach), name: .removeBreach, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tryingAddBreaches), name: .tryingAddBreaches, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .updateQuestionAswered, object: nil)
        NotificationCenter.default.removeObserver(self, name: .showPauseReason, object: nil)
        NotificationCenter.default.removeObserver(self, name: .hideKeyboard, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addBreach, object: nil)
        NotificationCenter.default.removeObserver(self, name: .removeBreach, object: nil)
        NotificationCenter.default.removeObserver(self, name: .tryingAddBreaches, object: nil)
        self.delegate?.countBreaches(count: self.countNewBreaches)
        self.isShowingPause = false
        self.footerDissapear()
       
    }
    
    func footerDissapear(){
        let width = self.questionsView.frame.width
        let heigth = self.questionsView.frame.height
        let frameFooter = CGRect(x: 0, y: heigth, width: width, height: (self.spaceQuestion  - 10))
        self.footerQuestion?.frame = frameFooter
    }
    func setModule(module: [String: Any]){
        self.currentModule = module
        self.questions.removeAll()
        if self.questionsView != nil {
            self.questionsView.subviews.forEach({ $0.removeFromSuperview() })
        }
        self.currentQuestion = module[KeysModule.currentQuestion.rawValue] as? Int ?? 0
        self.questionsDicto.removeAll()
    }
    func loadQuestions() {
        self.questionsView.addSubview(self.footerQuestion!)
        let questionFactory = QuestionFactory(frame: self.questionsView.bounds, positionY: spaceQuestion, sizeNotSelected: self.spaceQuestion)
        let optionalQuestions = self.questionsDicto.map({question in
            questionFactory.buildQuestion(question: question, isEditingSuperviion: self.isEditingSupervision, delegate: self,vc: self)})
        self.questions = optionalQuestions.compactMap{$0}
        for question in self.questions {
            self.questionsView.addSubview(question.questionView)
        }
        self.updateQuestionActive()
    }
    func updateQuestionActive() {
        self.view.endEditing(true)
        if currentQuestion > 0 {
            var posQuestionTop : CGFloat = 5
            for i in (0...(currentQuestion - 1)).reversed()  {
                self.questions[i].setQuestionActive(active: false, posY: posQuestionTop, speedAnimation: self.speedAnimation)
                posQuestionTop -= spaceQuestion
                self.questions[i].questionView.alpha = 1
            }
        }
        self.questions[currentQuestion].questionView.alpha = 1
        self.questions[currentQuestion].setQuestionActive(active: true, posY: self.spaceQuestion, speedAnimation: self.speedAnimation)
        if currentQuestion < self.questions.count - 1 {
            var posQuestionBottom = self.questionsView.bounds.size.height - CGFloat(spaceQuestion - 5)
            for i in (currentQuestion + 1)..<self.questions.count {
                self.questions[i].setQuestionActive(active: false, posY: posQuestionBottom, speedAnimation: self.speedAnimation)
                posQuestionBottom += spaceQuestion
                if !self.questions[currentQuestion].questionAnswered {
                     self.questions[i].questionView.alpha = 0.5
                } else {
                    self.questions[i].questionView.alpha = 1
                }
            }
        }
    }
    @IBAction func panGesture(_ sender: Any) {
        if self.questions.count == 0 || self.currentQuestion >= self.questions.count {
            return
        }
        if self.questions[self.currentQuestion].isInFullMode() {
            self.view.endEditing(true)
            return
        }
        guard let panGesture = sender as? UIPanGestureRecognizer else { return }
        let ySpeed = panGesture.velocity(in: self.questionsView).y
        if abs(ySpeed) < 100 || self.blockQuestion{ return }
        switch abs(ySpeed) {
            case 99...500:
                self.speedAnimation = 0.5
            case 501...1000:
                self.speedAnimation = 0.25
            case 1001...:
                self.speedAnimation = 0.1
            default:
                self.speedAnimation = 1.0
        }
        self.blockQuestion = true
        let dispatch: Double = Double(self.speedAnimation * 1.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatch, execute: {
            [unowned self] in
            self.blockQuestion = false
        })
        
        if self.keyboardShowed {
            self.view.endEditing(true)
            return
        }
        if ySpeed < 0 {
            self.questionUp()
        }else{
            self.questionDown()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func questionUp(){
        if self.questions.count > 0{
        if self.questions[self.currentQuestion].hasBreachPendient() {
            self.questions[self.currentQuestion].openBreachReasons()
            return
        }
        if !self.questions[self.currentQuestion].questionAnswered {
            return
        }
        self.saveQuestion()
        var percent = Int(((self.currentQuestion + 1) * 100) / self.questions.count)
        if self.currentQuestion < self.questions.count - 1 {
            self.currentQuestion += 1
            self.updateQuestionActive()
            if self.currentQuestion == self.questions.count - 1 {
                let heigth = self.questionsView.frame.height
                let yPos = heigth - self.spaceQuestion
                UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                    self.footerQuestion?.frame.origin.y = yPos
                })
            }
        } else {
            let questionNotAnswered = self.questionNotAnswered()
            if questionNotAnswered == -1 {
                percent = 100
                self.questions[self.currentQuestion].setQuestionActive(active: false, posY: 5, speedAnimation: self.speedAnimation)
                self.footerQuestion?.endModule()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.currentQuestion = questionNotAnswered
                self.updateQuestionActive()
            }
        }
        guard let moduleID = self.currentModule[KeysModule.id.rawValue] as? Int else {return}
        self.delegate?.updatePercent(idModule: moduleID, currentQuestion: self.currentQuestion, percent: percent)
        SupervisionModulesViewModel.shared.updateModule(idModule: moduleID, currentQuestion: currentQuestion, percent: percent)
        }
    }
    func questionNotAnswered()->Int {
        for (i, question) in self.questions.enumerated() {
            if !question.questionAnswered {
                return i
            }
        }
        return -1
    }
    func saveQuestion(){
        let (id, actionId, action, comment, hasBreach, dateSolutionCommon) = self.questions[self.currentQuestion].getQuestionResponse()
        
        self.questions[self.currentQuestion].checkSendEmail()
        QuestionViewModel.shared.updateQuestionResponse(idQuestion: id, dateSolutionCommon: dateSolutionCommon,actionId: actionId, actionDescription: action, comment: comment, hasBreach: hasBreach, completeBreach: self.questions[self.currentQuestion].reachedReasonsComplete)
        QuestionViewModel.shared.saveQuestion(idQuestion: id, isEditing: self.isEditingSupervision)
    }
    func questionDown() {
        if self.currentQuestion > 0 {
            self.saveQuestion()
            self.currentQuestion -= 1
            self.updateQuestionActive()
        }
        self.saveQuestion()
        self.footerDissapear()
    }
}
extension SupervisionListFormViewController: ProtocolBreanch{
    func updateBreach() {
         self.saveQuestion()
       
    }
    
    
}
