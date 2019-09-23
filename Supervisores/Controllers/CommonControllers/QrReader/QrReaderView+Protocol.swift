//
//  QrReaderView+Protocol.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 4/2/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

extension QrReaderViewController: SupervisionResumeProtocol, EndSupervisionVMProtocol {
    func sendSupervision(get: Bool) -> [String : Any] {
        sendSupervision()
        return [String : Any]()
    }
    
    func sendSupervision() {
        self.lottieView?.animationLoading()
        LoadSupervisionToSend.shared.getSupervisionToSend(complete: self.supervisionComplete, isVisit: false){
            EndSupervision.shared.setEndListener(listener: self)
            EndSupervision.shared.sendSuperVision(supervision: $0)
        }
    }
    func supervisionSendedError(error: Error) {
        self.lottieView?.animationFinishError()
    }
    func supervisionSendedOk(idSupervision: Int, rate: Int, descriptionSupervision: String, unitName: String, keyUnit: String, unitType: Int) {
        DispatchQueue.main.async {
            self.lottieView?.animationFinishCorrect()
            self.viewSupervisionInCourse.isHidden = true
            Storage.shared.deleteCurrentSupervision(isEditing: false)
            if self.supervisionComplete {
                let supervisionEnded = SupervisionFinishViewController()
                supervisionEnded.idSupervision = idSupervision
                supervisionEnded.keyUnit = keyUnit
                supervisionEnded.stars = rate
                supervisionEnded.descriptionSupervision = descriptionSupervision
                supervisionEnded.unitName = unitName
                self.present(supervisionEnded, animated: true, completion: nil)
            }
            if (self.captureSession?.isRunning == false) {
                self.captureSession.startRunning()
            }
            
            self.dismiss(animated: true, completion: nil)
            self.qrView.isHidden = false
        }
    }
}
