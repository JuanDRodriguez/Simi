//
//  SavePause.swift
//  Supervisores
//
//  Created by Sharepoint on 9/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

protocol SavePauseRemotly {
    func savePauseInServer()
}

struct SavePause: SavePauseRemotly {
    static let shared = SavePause()
    
    func savePauseInServer() {
        LoadSupervisionToSend.shared.getSupervisionToSend(complete: false, isVisit: false) {
            
            EndSupervision.shared.sendSuperVision(supervision: $0)
        }
    }
}
