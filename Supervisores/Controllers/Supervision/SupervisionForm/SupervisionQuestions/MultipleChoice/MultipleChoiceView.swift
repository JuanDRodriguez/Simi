//
//  MultipleChoiceView.swift
//  Supervisores
//
//  Created by Sharepoint on 11/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class MultipleChoiceView: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableOptions: UITableView!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var viewBreachReason: UIView!
    @IBOutlet weak var heigthViewBreach: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBreach: NSLayoutConstraint!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblLegend: UILabel!
    @IBOutlet weak var bottomLegendConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTxtComment: NSLayoutConstraint!
    @IBOutlet weak var heightCommentConstraint: NSLayoutConstraint!
    var delegate: ProtocolBreanch?
    var questionChanged = QuestionChanged.noChange
    var questionLoaded = false
    var isEditingSupervision: Bool = false
    var hasBreach: Bool = false
    var hiddenViews : [UIView]! = []
    var nibView: UIView!
    var question : [String: Any]
    var optionBreach : [String: Any]?
    var optioBreach2 : [[String: Any]] = []
    var questionSize: CGFloat = 0.0
    var breachReason : BreachReasonProtocol?
    var breachReasonButton : BreachReasonButton? = nil
    let breachReasonFactory = BreachReasonFactory()
    var isFullMode = false
    var reachedReasonsComplete = false
    var isSelectedCell = false
    var updateContrains = false
    var options : [[String: Any]] = []
    var numberBreach = 0
    var questionAnswered = false
    var checkBreachesComplete = false
    var vc: UIViewController!
    init(selected: Bool, question:[String: Any], frame: CGRect, isEditingSupervision: Bool) {
        self.isEditingSupervision = isEditingSupervision
        self.question = question
        super.init(frame: frame)
        self.isSelectedCell = selected
        self.layer.masksToBounds = true
        self.nibView  = Bundle.main.loadNibNamed("MultipleChoiceView", owner: self, options: nil)![0] as! MultipleChoiceView
        self.nibView .frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(self.nibView )
        let nib = UINib(nibName: "ChoiceCell", bundle: nil)
        self.tableOptions.register(ChoiceCell.self, forCellReuseIdentifier: Cells.choiceCell.rawValue)
        self.tableOptions.register(nib, forCellReuseIdentifier: Cells.choiceCell.rawValue)
        self.layoutIfNeeded()
        self.checkTitles()
        self.checkComment()
        self.hideBreach()
        
        self.tableOptions.rowHeight = UITableView.automaticDimension
        self.tableOptions.estimatedRowHeight = 60
        
        if var options = question[KeysQuestion.options.rawValue] as? [[String: Any]] {
            print("\(options)")
            
            for var option in options {
               let dParameters = try? JSONSerialization.data( withJSONObject: option, options: [])
                let decoded = String(data: dParameters!, encoding: .utf8)!
                print("jd\(decoded)")
                if let select = option[KeysOptionQuestion.selected.rawValue] as? Bool{
                    self.checkBreaches(option: option, checked: select, substactValid: false)
                    if select {
                        self.questionAnswered = true
                    }
                }
                self.options.append(option)
                if let breaches = option[KeysOptionQuestion.breaches.rawValue] as? [[String: Any]]{
                    if breaches.count > 0 {
                        self.optioBreach2.append(option)
                    }else{
                        self.optioBreach2.append([:])
                    }
                }
            }
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !self.checkBreachesComplete && self.hasBreach {
            self.checkBreachesComplete = true
            if let breachComplete = self.question[KeysQuestion.breachEnded.rawValue] as? Bool {
                if breachComplete {
                    self.formComplete(complete: breachComplete, moveView : false)
                }
            }
        }
    }
    
    func hideBreach() {
        self.hasBreach = false
        self.viewBreachReason.isHidden = true
        self.showComments()
        self.heigthViewBreach.constant = 0
        self.bottomViewBreach.constant = 0
    }
    
    func showBreach() {
        self.viewBreachReason.isHidden = false
        self.hasBreach = true
        self.hiddeComments()
        self.heigthViewBreach.constant = 40
        self.bottomViewBreach.constant = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.breachReasonButton == nil {
                self.breachReasonButton = BreachReasonButton(frame:CGRect(x: 0.0, y: 0.0, width: self.viewBreachReason.bounds.width, height: 40.0) ){
                    [unowned self] in
                    self.openBreachReasons()
                }
                self.viewBreachReason.addSubview(self.breachReasonButton!)
            } else  {
                self.breachReasonButton?.frame.size.height = self.viewBreachReason.bounds.height
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.question = [:]
        super.init(coder: aDecoder)
    }
    func updateQuestion(){
        if let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int {
            if let q = QuestionViewModel.shared.getQuestionBy(id: idQuestion){
                self.question = q
            }
        }
    }
}
