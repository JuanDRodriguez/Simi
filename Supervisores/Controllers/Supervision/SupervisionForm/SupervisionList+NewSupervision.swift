//
//  SupervisionList+NewSupervision.swift
//  Supervisores
//
//  Created by Sharepoint on 5/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//


import Foundation

extension SupervisionListFormViewController {
    func createNewSupervision() {
        let currentUnit = CurrentSupervision.shared.getCurrentUnit()
        let supervisionInfo = Storage.shared.getCurrentSupervision()
        Storage.shared.deleteCurrentSupervision(isEditing: true, creatingNewSupervision: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.delegate?.newSupervisionFromAddBreaches()
            CurrentSupervision.shared.setCurrentUnit(unit: currentUnit)
            
            let supervisionData = SupervisionData(idUnit: supervisionInfo.idUnit,
                                                  unitName: supervisionInfo.unitName,
                                                  typeUnit: supervisionInfo.typeUnit,
                                                  supervisorKey: supervisionInfo.supervisorKey,
                                                  statusUnit: supervisionInfo.statusUnit,
                                                  nameSupervisor: supervisionInfo.nameSupervisor,
                                                  domainAccount: supervisionInfo.domainAccount,
                                                  completion: false, dateStart: nil)
            
            let _ = Storage.shared.startSupervision(supervisionData: supervisionData)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func continueWithSupervision() {
        
    }
}
