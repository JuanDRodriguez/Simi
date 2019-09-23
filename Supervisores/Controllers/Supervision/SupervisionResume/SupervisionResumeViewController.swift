//
//  SupervisionResumeViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 14/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//
import UIKit
import Lottie

protocol SupervisionResumeProtocol: class {
    func sendSupervision(get: Bool) -> [String: Any]
}

class SupervisionResumeViewController: UIViewController {
    
    @IBOutlet weak var viewNav: UIView!
    @IBOutlet weak var stackUnitNumber: UIStackView!
    @IBOutlet weak var stackUnitName: UIStackView!
    @IBOutlet weak var stackUnitAddress: UIStackView!
    @IBOutlet weak var stackUnitDate: UIStackView!
    @IBOutlet weak var stackSupervisorKEy: UIStackView!
    @IBOutlet weak var stackDomainAccount: UIStackView!
    @IBOutlet weak var heightStarsConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewStar1: UIView!
    @IBOutlet weak var viewStar2: UIView!
    @IBOutlet weak var viewStar3: UIView!
    @IBOutlet weak var viewStar4: UIView!
    @IBOutlet weak var viewStar5: UIView!
    @IBOutlet weak var tableViewBreaches: UITableView!
    
    @IBOutlet weak var heightConstraintDetails: NSLayoutConstraint!
    @IBOutlet weak var heightContraintStars: NSLayoutConstraint!
    @IBOutlet weak var stackViewStars: UIStackView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var heighDetailsConstaint: NSLayoutConstraint!
    @IBOutlet weak var lblUnitKey: UILabel!
    @IBOutlet weak var lblUnitName: UILabel!
    @IBOutlet weak var lblUnitAddress: UILabel!
    @IBOutlet weak var lblSupervisionDate: UILabel!
    @IBOutlet weak var lblSupervisorKey: UILabel!
    @IBOutlet weak var lblAccountSupervisor: UILabel!
    @IBOutlet weak var lblEtiquetaAccount: UILabel!
    @IBOutlet weak var btnSendSupervision: UIButton!
    @IBOutlet weak var heightSendSConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSendSConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSendSConstraint: NSLayoutConstraint!
    weak var delegate: SupervisionResumeProtocol?
    var lottieView : LottieViewController?
    var answerByModule : [String: [[String: Any]]] = [:]
    var arrayHeaders: [String] = []
    var supervisionId = 0
    var lottieStars : [LOTAnimationView] = []
    var isDetail = false
    var isOnlyBreaches = false
    var canEdit = false
    var unitId = -1
    var totalAnswer : [[String: Any]] = []
    var totalModules: [Int] = []
    var supervisionLoaded = false
    var delagatefail : ResumenSuperVisionDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        var title = ""
        if self.isDetail {
            title = "Detalle de supervisión"
            self.heighDetailsConstaint.constant = 220
        } else {
            self.heighDetailsConstaint.constant = 170
            title = "Vista previa de supervisión"
            self.heightStarsConstraint.constant = 0
            self.stackViewStars.isHidden = true
            self.heightContraintStars.constant = 0
            self.heighDetailsConstaint.constant = 180
//            self.stackFolio.isHidden = true
        }
        CommonInit.navBarGenericBack(vc: self, navigationBar: self.viewNav, title: title)
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        let nib = UINib(nibName: "ResumeSupervisionCell", bundle: nil)
        self.tableViewBreaches.register(ResumeSupervisionCell.self, forCellReuseIdentifier: Cells.resumeCell.rawValue)
        self.tableViewBreaches.register(nib, forCellReuseIdentifier: Cells.resumeCell.rawValue)
        self.tableViewBreaches.rowHeight = UITableView.automaticDimension
        self.tableViewBreaches.estimatedRowHeight = 485
        
        
    }
    func setPreviewInfo(unitKey: String, unitName: String, address: String, dateSupervision: String, supKey: String, typeUnit: String,nameSup: String!, domainAccount: String) {
        lblUnitKey.text = unitKey
        lblUnitName.text = unitName
        lblUnitAddress.text = address
        lblSupervisionDate.text = dateSupervision
        lblSupervisorKey.text = "\(supKey)"
        lblAccountSupervisor.text = "\(domainAccount) - \(nameSup!)"
        
        if typeUnit == "Sucursal" {
//            stackDomainAccount.isHidden = true
            
        }else{
            lblEtiquetaAccount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func setDetail(isDetail: Bool) {
        self.isDetail = isDetail
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.supervisionLoaded {
            return
        }
        if self.isDetail {
            EndSupervision.shared.setGetResumeListener(listener: self)
            if self.canEdit {
                self.btnSendSupervision.setTitle("Editar supervisión", for: .normal)
            } else  {
                self.btnSendSupervision.isHidden = true
                self.heightSendSConstraint.constant = 0
                self.bottomSendSConstraint.constant = 0
                self.topSendSConstraint.constant = 0
            }
        } else {
            //let answersSupervision = setPhotosToAnswers(photos: (self.delegate?.sendSupervision(get: true))!, answers: )
            
           self.loadAnswersSupervision(answersSupervision: PreviewSupervisionViewModel.shared.getPreviewSupervision())
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.supervisionLoaded {
            return
        }
        if self.isDetail {
            if self.lottieStars.count <= 0 {
                let sizeLottie = self.viewStar1.frame.width * 1.5
                let centerAnim = CGPoint(x: self.viewStar1.frame.width / 2.0 , y: self.viewStar1.frame.height / 2.0)
                for _ in 0..<5 {
                    let lottie = LOTAnimationView(name: "star")
                    lottie.isUserInteractionEnabled = false
                    lottie.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
                    self.lottieStars.append(lottie)
                }
                self.viewStar1.addSubview(self.lottieStars[0])
                self.lottieStars[0].center = centerAnim
                self.viewStar2.addSubview(self.lottieStars[1])
                self.lottieStars[1].center = centerAnim
                self.viewStar3.addSubview(self.lottieStars[2])
                self.lottieStars[2].center = centerAnim
                self.viewStar4.addSubview(self.lottieStars[3])
                self.lottieStars[3].center = centerAnim
                self.viewStar5.addSubview(self.lottieStars[4])
                self.lottieStars[4].center = centerAnim
            }
            EndSupervision.shared.getSupervision(supervisionId: self.supervisionId)
            self.lottieView?.animationLoading()
        }
        self.supervisionLoaded = true
    }
    @IBAction func sendSupervision(_ sender: Any) {
        if self.canEdit {
            if self.unitId != -1 {
                let qrView = QrReaderViewController()
                if let nameUnit = self.lblUnitName.text {
                    qrView.nameUnitEdit = nameUnit
                }
                qrView.idUnitEdit = self.unitId
                qrView.delegate = self
                self.present(qrView, animated: true, completion: nil)
            }
        } else {
           _ = self.delegate?.sendSupervision(get: false)
            self.dismiss(animated: false, completion: nil)
        }
    }
}

