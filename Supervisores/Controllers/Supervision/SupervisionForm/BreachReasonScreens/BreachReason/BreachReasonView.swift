//
//  BreachReasonView.swift
//  Supervisores
//
//  Created by Sharepoint on 13/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//
import UIKit
import Lottie

enum TypeBreach: String {
    case critic = "Critico"
    case noCritic = "No critico"
}

class BreachReasonView: UIView {
    @IBOutlet weak var viewPhotos: UIView!
    @IBOutlet weak var tableViewBreach: UITableView!
    @IBOutlet weak var txtCommentBreach: UITextView!
    @IBOutlet weak var viewActionBreach: UIView!
    @IBOutlet weak var bottomCommentConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackActionView: UIStackView!
    @IBOutlet weak var bottomActionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightBreachConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContetScroll: UIView!
    @IBOutlet weak var heightPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightCommentConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewDateBreach: UIView!
    @IBOutlet weak var bottomListConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightActionConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnDateSolution: UIButton!
    @IBOutlet weak var btnActionSelection: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnAddAlert: UIButton!
    
    @IBOutlet weak var viewBreaches: UIView!
    @IBOutlet var viewTableBreach: UIView!
    @IBOutlet var scrollTexts: UIScrollView!
    
    var lottieViewAlert = LOTAnimationView(name: "alarma")
    var lottieCreated = false
    var datePickerView : PickerDateView?
    var optionsPickerView : PickerSelectView?
    var updateContrains = false
    var updateContrainsSubviews = false
    var photos : PhotosView?
    var delegate: BreachReasonAnswerProtocol?
    var question: [String: Any] = [:]
    var solutionDate : Bool = false
    var hasBreachLevel : Bool = false
    var option: [String: Any]
    var breaches: [[String: Any]] = []
    var breachDate: [String: Any]?
    var breachLevel: [String: Any]?
    var scrollSize : CGFloat = 0.0
    let cellSize = 80
    var commentforced = false
    var photoForced = false
    var generalDate = false
    var dateSolutionCommon : Date? = nil
    var hasSuboptions = false
    var actions : [[String: Any]] = []
    var arrayBreachOptions : [[String: Any]] = []
    var photosCapture: [UIImage]!
    var breachUpdated: [String: Any]!
    var vc: UIViewController!
    init(question:[String: Any], option:[String: Any]?, frame: CGRect) {
        self.vc =  SupervisionListFormViewController.vc
        if let opt = option {
            if let solutionD = opt[KeysOptionQuestion.dateSolution.rawValue] as? Bool {
                self.solutionDate = solutionD
            }
            if let breachL = opt[KeysOptionQuestion.breachLevel.rawValue] as? Bool {
                self.hasBreachLevel = breachL
                
            }
            self.option = opt
        } else {
            self.option = [:]
        }
        self.question = question
        let currentUnit = CurrentSupervision.shared.getCurrentUnit()
        super.init(frame: frame)
        self.layer.masksToBounds = true
        let view = Bundle.main.loadNibNamed("BreachReasonView", owner: self, options: nil)![0] as! BreachReasonView
        view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(view)
        self.checkBreaches()
        self.btnAddAlert.isEnabled = false
        let nib = UINib(nibName: "BreachCell", bundle: nil)
        self.tableViewBreach.register(BreachCell.self, forCellReuseIdentifier: Cells.breachCell.rawValue)
        self.tableViewBreach.register(nib, forCellReuseIdentifier: Cells.breachCell.rawValue)
        self.tableViewBreach.rowHeight = UITableView.automaticDimension
        self.tableViewBreach.estimatedRowHeight = CGFloat(self.cellSize)
        self.checkComment()
        self.checkPhoto()
        self.checkDate()
        self.checkActions()
        self.checkBreachs(height: Int(frame.height), width: Int(frame.width))
        self.scrollContainer.delegate = self
        self.scrollContainer.addSubview(self.viewContetScroll)
        NotificationCenter.default.addObserver(self, selector: #selector(showDatePicker(notification:)), name: .showDatePickerBereach, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLevelBreach(notification:)), name: .showLevelBreach, object: nil)
        if self.actions.count == 1 {
            self.btnActionSelection.isEnabled = false
        }
        self.viewBreaches.layer.masksToBounds = true
        self.layoutSubviews()
        self.updateContrains = true
        self.btnActionSelection.isEnabled = false
        if let typeUnit = currentUnit[KeysQr.typeUnit.rawValue] as? String {
            ActionsViewModel.shared.setListener(listener: self)
            ActionsViewModel.shared.getActions(type: (typeUnit == KeysUnitType.branchOffice.rawValue ? "S" : "F"))
        }
    }
    
    func updateOption(option: [String: Any]?) {
        if let opt = option {
            self.option = opt
            self.tableViewBreach.reloadData()
        }
    }
    override func layoutSubviews() {
        super.updateConstraints()
        if updateContrains {
            self.updateContrains = false
            self.viewContetScroll.frame = CGRect(x: 0, y: 0, width: Int(frame.size.width - 4), height: Int(self.scrollSize + 5))
            self.scrollContainer.contentSize = self.viewContetScroll.bounds.size
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.updateContrainsSubviews = true
                self.updateConstraints()
            }
        }
    }
    override func updateConstraints() {
        super.updateConstraints()
        if updateContrainsSubviews {
            self.updateContrainsSubviews = false
            let scrollMinSize = (self.scrollContainer.frame.height - 5)
            self.scrollSize = self.scrollSize < scrollMinSize ? scrollMinSize : self.scrollSize
            self.viewContetScroll.frame.size.height = self.scrollSize
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                for view in self.viewBreaches.subviews {
                    view.frame = self.viewBreaches.bounds
                }
                if self.photos == nil && !self.viewPhotos!.isHidden {
                    if let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int {
                        self.photos = PhotosView(frame: self.viewPhotos!.bounds, questionId: idQuestion,type: .supervision,vc: self.vc)
                        self.viewPhotos!.addSubview(self.photos!)
                        if let qPhotos = self.question[KeysQuestion.listPhotos.rawValue] as? [UIImage]{
                            self.photos?.setPhotos(images: qPhotos)
                            self.photosCapture = qPhotos
                           
                        }
                        
                        if self.photoForced {
                            self.photos?.setTitle(title: "Evidencia fotográfica (obligatoria)")
                        } else {
                            self.photos?.setTitle(title: "Evidencia fotográfica")
                        }
                        
                    }
                    
                }
                if !self.lottieCreated {
                    self.lottieCreated = true
                    self.lottieViewAlert.animationSpeed = 1.5
                    self.lottieViewAlert.isUserInteractionEnabled = false
                    let widthAlert = self.btnAddAlert.frame.width * 1.2
                    self.lottieViewAlert.frame = CGRect(x: 0.0, y: 0.0, width: widthAlert, height: widthAlert)
                    self.lottieViewAlert.center = CGPoint(x: self.btnAddAlert.frame.width / 2.0, y: self.btnAddAlert.frame.height / 2.0)
                    self.btnAddAlert.addSubview(self.lottieViewAlert)
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        self.option = [:]
        self.actions = []
        super.init(coder: aDecoder)
    }
    @objc func showDatePicker(notification: NSNotification){
        self.breachDate = notification.object as? [String: Any]
        self.checkDatePicker()
    }
    @objc func showLevelBreach(notification: NSNotification){
        self.breachLevel = notification.object as? [String: Any]
        if self.arrayBreachOptions.count == 0 {
            BreachLevelViewModel.shared.setListener(listener: self)
            BreachLevelViewModel.shared.getBreachesLevel()
            return
        }
        let arrayStrings: [String] = self.arrayBreachOptions.map({
            guard let breachName = $0[KeysBreachLevel.name.rawValue] as? String else {return " "}
            return breachName
        })
        self.checkOptionsPicker(options: arrayStrings)
    }
    @IBAction func openActionSelection(_ sender: Any) {
        let actionsMapped: [String] = self.actions.map({
            if let name = $0[KeysActions.name.rawValue] as? String {
                return name
            }
            return ""
        })
        self.checkOptionsPicker(options: actionsMapped)
    }
    @IBAction func openDateSelection(_ sender: Any) {
        self.breachDate = nil
        self.checkDatePicker()
        NotificationCenter.default.post(name: .hideKeyboard, object: nil)
    }
    @IBAction func addAlert(_ sender: Any) {
        let currentSupervision = CurrentSupervision.shared.getCurrentUnit()
        let currentModule = CurrentSupervision.shared.getCurrentModule()
        guard let titleBtnDate = self.btnDateSolution.title(for: .normal) else {return}
        guard let topic = self.question[KeysQuestion.topic.rawValue] as? String else {return}
        guard let question = self.question[KeysQuestion.question.rawValue] as? String else {return}
        guard let module = currentModule[KeysModule.name.rawValue] as? String else {return}
        guard let unitName = currentSupervision[KeysQr.nameUnit.rawValue] as? String else {return}
        guard let keyUnit = currentSupervision[KeysQr.keyUnit.rawValue] as? String else {return}
        if let date = Utils.dateFromString(stringDate: titleBtnDate) {
            Utils.addReminder(dateAlert: date, title: "\(keyUnit)-\(unitName)", description: "\(module) - \(topic) : \(question)"){[unowned self](granted, error) in
                if granted && error  == nil {
                    Utils.runAnimation(lottieAnimation: self.lottieViewAlert, from: 0, to: 60)
                }
            }
        }
    }
    
    @IBAction func saveNClose(_ sender: Any) {
      
        var breachComplete = true
        if self.hasSuboptions {
            for textField in self.scrollContainer.subviews {
                if let txtField = textField as? UITextField {
                    if txtField.text == "" {
                        breachComplete = false
                        //                        txtField.backgroundColor = Color.missing.rawValue
                        //                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        //                            txtField.backgroundColor = .white
                        //                        }
                    } else {
                        if let idQuestion = self.question[KeysQuestion.id.rawValue] as? Int {
                            if let idOption = self.option[KeysOptionQuestion.id.rawValue] as? Int {
                                QuestionViewModel.shared.updateOptionSuboption(idQuestion: idQuestion, idOption: idOption, idSuboption: txtField.tag, answer: txtField.text ?? "")
                            }
                        }
                    }
                }
            }
        } else  {
            if self.commentforced {
                if self.txtCommentBreach.text == "" {
                    self.txtCommentBreach.backgroundColor = Color.missing.rawValue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.txtCommentBreach.backgroundColor = .white
                    }
                    breachComplete = false
                }
            }
            if self.photoForced {
                if self.photos?.currentPhoto == 0 {
                  
                    breachComplete = false
                }
            }
            
            if self.generalDate {
                if self.dateSolutionCommon == nil {
                    //                self.viewDateBreach.backgroundColor = Color.missing.rawValue
                    //                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    //                    self.viewDateBreach.backgroundColor = .white
                    //                }
                    breachComplete = false
                }
            }
        }
        //        if breachComplete {
        if let idOption = self.option[KeysOptionQuestion.id.rawValue] as? Int {
            self.delegate?.updateSuptions(optionID: idOption)
        }
        self.delegate?.formComplete(complete: breachComplete, moveView: true)
       
        //        }
        
    }
}
