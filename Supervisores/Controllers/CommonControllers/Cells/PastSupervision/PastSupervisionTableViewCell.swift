//
//  PastSupervisionTableViewCell.swift
//  Supervisores
//
//  Created by Sharepoint on 5/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class PastSupervisionTableViewCell: UITableViewCell {
    
    typealias detailSupervision = (Int) -> Void
    typealias detailVisit = (VisistItem) -> Void
    
    @IBOutlet weak var btnSupervsionType: UIButton!
    @IBOutlet weak var btnNumberBreaches: UIButton!
    
    @IBOutlet weak var lblDateBegin: UILabel!
    @IBOutlet weak var lblHourBegin: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    @IBOutlet weak var lblHourEnd: UILabel!
    @IBOutlet weak var viewStar1: UIView!
    @IBOutlet weak var viewStar2: UIView!
    @IBOutlet weak var viewStar3: UIView!
    @IBOutlet weak var viewStar4: UIView!
    @IBOutlet weak var viewStar5: UIView!
    @IBOutlet weak var stackView: UIStackView!
    var showDetail: detailSupervision?
    var showBreaches: detailSupervision?
    var showVisit: detailVisit?
    var supervisionId : Int = -1
    var isVisit = false
    var lottieStars : [LOTAnimationView] = []
    var visit: VisistItem!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setVisit(visit: VisistItem, showDeatail: @escaping detailVisit)  {
        self.showVisit = showDeatail
        self.visit = visit
        self.stackView.isHidden = true
        if Utils.dateCampareToDateNow(stringDate: (GeneralCloseModel.shared.generalClose!.HoraInicio,GeneralCloseModel.shared.generalClose!.HoraFin)){
           
            self.btnSupervsionType.setImage(UIImage(named: "luna"), for: .normal)
        }else{
            self.btnSupervsionType.setImage(UIImage(named: "sol"), for: .normal)
        }
       let date = Utils.dateFromService(stringDate: visit.FechaFin!)
        let date2 = Utils.dateFromService(stringDate: visit.FechaInicio!)
       // print("FechaRegistro: \(visit.FechaRegistro)")
       self.lblDateEnd.text = Utils.stringFromDate(date: date)
       self.lblHourEnd.text = Utils.stringHourFromDate(date: date)
        self.lblDateBegin.text = Utils.stringFromDate(date: date2)
        self.lblHourBegin.text = Utils.stringHourFromDate(date: date2)
        self.btnNumberBreaches.setTitle("", for: .normal)
    }
    func setInfoSupervision(infoLabel: [String: Any], showDetail: @escaping detailSupervision, showBreaches: @escaping detailSupervision) {
        self.showDetail = showDetail
        self.showBreaches = showBreaches
        if let isVisit = infoLabel[KeysPastSupervision.isVisit.rawValue] as? Bool {
            if isVisit {
                self.btnSupervsionType.setImage(UIImage(named: "iconVisitaR"), for: .normal)
            } else  {
                self.btnSupervsionType.setImage(UIImage(named: "iconSupervisionR"), for: .normal)
            }
            
        }
        if let dateBegin = infoLabel[KeysPastSupervision.dateBegin.rawValue] as? Date {
            self.lblDateBegin.text = Utils.stringFromDate(date: dateBegin)
            self.lblHourBegin.text = Utils.stringHourFromDate(date: dateBegin)
        }
        if let dateEnd = infoLabel[KeysPastSupervision.dateEnd.rawValue] as? Date {
            self.lblDateEnd.text = Utils.stringFromDate(date: dateEnd)
            self.lblHourEnd.text = Utils.stringHourFromDate(date: dateEnd)
        }
        if let numberBreaches = infoLabel[KeysPastSupervision.numberBreaches.rawValue] as? Int {
            self.btnNumberBreaches.setTitle("\(numberBreaches)", for: .normal)
        }
        if let numberStars = infoLabel[KeysPastSupervision.numberStars.rawValue] as? Int {
            for i in 0..<numberStars {
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                    self.createStars()
                    DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                        let stars = i
                        if stars >= 0 && stars < self.lottieStars.count {
                            Utils.runAnimation(lottieAnimation: self.lottieStars[stars], from: 0, to: 30)
                        }
                    })
                })
            }
        }
        if let supId = infoLabel[KeysPastSupervision.supervisionId.rawValue] as? Int {
            self.supervisionId = supId
        }
    }
    
    func createStars(){
        if lottieStars.count == 0 {
            let sizeLottie = self.viewStar1.frame.width * 2.1
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
    }
    
    @IBAction func goToSupervisionDetail(_ sender: Any) {
        
        if isVisit{
           
                self.showVisit!(self.visit)
            
            
        }else{
        if let showDetail = self.showDetail {
            showDetail(self.supervisionId)
        }
        }
    }
    
    @IBAction func goToBreachesDetail(_ sender: Any) {
        if let showBreaches = self.showBreaches {
            showBreaches(self.supervisionId)
        }
    }
}
