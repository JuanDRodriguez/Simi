//
//  SupervisionResume+Protocols.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

extension SupervisionResumeViewController: GetSupervisionResumeVMProtocol, QRReaderProtocol {
    func setTypeOption(type: typeOperationStore) {
        
    }
    
    func supervisionSendedError(error: Error) {
        self.lottieView?.animationFinishError()
    }
    
    func getResumeSupervision(supervisionInfo: [String : Any], unitInfo: [String : Any], answersSupervision: [[String : Any]]) {
        DispatchQueue.main.async {
            self.lottieView?.animationFinishCorrect()
//            if let supervisionId = supervisionInfo[KeysSupervisionInfo.supervisionId.rawValue] as? Int {
//                let s = String(supervisionId)
//                self.lblIdSupervision.text = s.leftPadding(toLength: 8, withPad: "0")
//            }
//            KeysAnswerResume.photos.rawValue
//            KeysPhotosResume.photo.rawValue
            self.unitId = unitInfo[KeysUnitDetailsResume.unitId.rawValue] as? Int ?? -1
            self.lblUnitKey.text = unitInfo[KeysUnitDetailsResume.unitKey.rawValue] as? String
            self.lblUnitName.text = unitInfo[KeysUnitDetailsResume.unitName.rawValue] as? String
            let street : String = unitInfo[KeysUnitDetailsResume.unitStreet.rawValue] as? String ?? ""
            let colony : String = unitInfo[KeysUnitDetailsResume.unitColony.rawValue] as? String ?? ""
            let ext : String = unitInfo[KeysUnitDetailsResume.unitNumberExt.rawValue] as? String ?? ""
            let array = MyUnitsViewModel.shared.arrayUnits.filter({self.unitId == $0.id})
            self.lblUnitAddress.text = "CALLE \(street), NUMERO\(ext) COLONIA \(colony) MUNICIPIO \(array[0].municipio!) CP \(array[0].cp)"
            if let date = supervisionInfo[KeysSupervisionInfo.dateEnd.rawValue] as? Date{
                self.lblSupervisionDate.text = Utils.stringFromDate(date: date)
            }
            if let supId = supervisionInfo[KeysSupervisionInfo.supervisorKey.rawValue] as? String {
                if let supName = LoginViewModel.shared.loginInfo?.user?.name , let domain = LoginViewModel.shared.loginInfo?.user?.domainAccount{
                    
                    self.lblSupervisorKey.text = "\(supId)"
                    self.lblAccountSupervisor.text =  "\(domain) - \(supName)"
                   
                }
            }
            
            print("SupervisionInfo: \(supervisionInfo)")
            if let typeUnit = supervisionInfo[KeysUnitDetailsResume.unitType.rawValue] as? Int {
                
                if typeUnit == UnitsType.branchOffice.rawValue {
                    self.stackDomainAccount.isHidden = false
                    self.lblAccountSupervisor.text = supervisionInfo[KeysSupervisionInfo.userAccount.rawValue] as? String
                }
            }
            if let rate = supervisionInfo[KeysSupervisionInfo.rate.rawValue] as? Int {
                for i in 0..<rate {
                    DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                        let stars = i
                        if stars >= 0 && stars < self.lottieStars.count {
                            Utils.runAnimation(lottieAnimation: self.lottieStars[i], from: 0, to: 30)
                        }
                    })
                }
            }
            self.loadAnswersSupervision(answersSupervision: answersSupervision)
        }
    }
    
    func loadAnswersSupervision(answersSupervision: [[String : Any]]) {
        self.totalAnswer = answersSupervision
        self.totalModules = answersSupervision.map({
            $0[KeysAnswerResume.moduleId.rawValue] as? Int  ?? -1
        })
        self.totalModules = Array(Set(totalModules))
        
        var answersBreach : [[String: Any]] = []
        if self.isOnlyBreaches {
            answersBreach = answersSupervision.filter({
                guard let weighing = $0[KeysAnswerResume.weighing.rawValue] as? Int else {return false}
                return weighing <= 0
            })
        } else {
            answersBreach = answersSupervision.filter({
                guard let weighing = $0[KeysAnswerResume.weighing.rawValue] as? Int else {return false}
                guard let comment = $0[KeysAnswerResume.comment.rawValue] as? String else {return false}
                return weighing <= 0 || comment != ""
            })
        }
        
        self.answerByModule.removeAll()
        self.arrayHeaders.removeAll()
        for answer in answersBreach {
            if let module = answer[KeysAnswerResume.moduleDescription.rawValue] as? String {
                let moduleClean = module.folding(options: .diacriticInsensitive, locale: .current)
                if self.answerByModule[moduleClean] != nil {
                    self.answerByModule[moduleClean]?.append(answer)
                } else {
                    self.answerByModule[moduleClean] = [answer]
                    
                    self.arrayHeaders.append(moduleClean)
                }
            }
        }
        self.tableViewBreaches.reloadData()
    }
    
    func readingQR(jsonInfo: [String : Any], wasOnPause: Bool,statusUnit: Int32) {
        
        let supervision = SupervisionViewController()
        supervision.modulesFilter = self.totalModules
        supervision.dissmisOnEnter = false
        supervision.unitInfo = jsonInfo
        CurrentSupervision.shared.setCurrentUnit(unit: jsonInfo)
//        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.isNavigationBarHidden = false
        
        guard let idUnit = jsonInfo[KeysQr.unitId.rawValue] as? Int else {return}
        guard let unitName = jsonInfo[KeysQr.nameUnit.rawValue] as? String else {return}
        guard let typeUnit = jsonInfo[KeysQr.typeUnit.rawValue] as? String else {return}
        guard let supervisorKey = jsonInfo[KeysQr.supervisorKey.rawValue] as? String else {return}
        let supervisor = jsonInfo["Supervisor"] as! [String : Any]
        let name = "\(supervisor["NombreCompleto"] as! String)"
        let domainAccount = "\(supervisor["CuentaDominio"] as! String)"
        
        supervision.nameSup = "\(supervisor["NombreCompleto"] as! String)"
        
        let supervisionData = SupervisionData(idUnit: idUnit,
                                              unitName: unitName,
                                              typeUnit: typeUnit,
                                              supervisorKey: supervisorKey,
                                              statusUnit: statusUnit,
                                              nameSupervisor: name,
                                              domainAccount: domainAccount,
                                              completion: false, dateStart: nil)
        
        
        
        let _ = Storage.shared.startSupervision(supervisionData: supervisionData)
        self.saveQuestionsLoaded(isEditing: true)
        supervision.isEditingSupervision = true
        self.present(supervision, animated: true, completion: nil)
    }
    
    func saveQuestionsLoaded(isEditing: Bool) {
        for answer in self.totalAnswer {
            QuestionViewModel.shared.saveDictoToAnswer(dictoAnswer: answer, isEditing: isEditing)
        }
    }
}
