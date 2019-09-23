//
//  SupervisionVireController+SendSupervision.swift
//  Supervisores
//
//  Created by Sharepoint on 12/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//


import Foundation
import MapKit

extension SupervisionViewController: EndSupervisionVMProtocol, SupervisionResumeProtocol {
    func sendSupervision(get: Bool) -> [String : Any] {
        let valueReturn = [String: Any]()
        let supData = Storage.shared.getCurrentSupervision()
        self.supervisionComplete = supData.completion
        self.lottieView?.animationLoading()
        
        LoadSupervisionToSend.shared.getSupervisionToSend(complete: self.supervisionComplete, isVisit: false) {
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: $0,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                //print("JSON string = \(theJSONText!)")
            }
            EndSupervision.shared.setEndListener(listener: self)
            EndSupervision.shared.sendSuperVision(supervision: $0)
        }
        return valueReturn
    }
    
    func sendSupervision(){
        
    }
    
    func supervisionSendedError(error: Error) {
        DispatchQueue.main.async {
            self.lottieView?.animationFinishError()
        }
    }
    
    func supervisionSendedOk(idSupervision: Int, rate: Int, descriptionSupervision: String, unitName: String, keyUnit: String, unitType: Int) {
        
        DispatchQueue.main.async {
            self.lottieView?.animationFinishCorrect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Storage.shared.deleteCurrentSupervision(isEditing: false)
                if self.supervisionComplete {
                    let supervisionEnded = SupervisionFinishViewController()
                    supervisionEnded.idSupervision = idSupervision
                    supervisionEnded.keyUnit = keyUnit
                    supervisionEnded.stars = rate
                    supervisionEnded.type = unitType
                    //print("Count Star = \(rate)")
                    supervisionEnded.descriptionSupervision = descriptionSupervision
                    supervisionEnded.unitName = unitName
                    self.present(supervisionEnded, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
