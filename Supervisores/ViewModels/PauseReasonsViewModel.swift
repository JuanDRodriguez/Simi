//
//  PauseReasons.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysPause: String {
    case id = "idReason"
    case active = "active"
    case reason = "reason"
    case dateModification = "dateModification"
    case dateRegister = "dateRegister"
    case datePublish = "datePublish"
}

@objc protocol PauseReasonsVMProtocol {
    func reasonsUpdated(reasons: [[String: Any]])
    func finishWithErrorReasons(error: Error)
    func finishLoadReasons()
}

class PauseReasonsViewModel {
    static let shared = PauseReasonsViewModel()
    var listener: PauseReasonsVMProtocol?
    var arrayReasons: [[String: Any]] = []
    init() {
        
    }
    var reasonsList: [PauseReason] = [] {
        didSet {
            self.arrayReasons.removeAll()
            for reason in reasonsList {
                if reason.active {
                    self.arrayReasons.append(pauseToDictionary(reason: reason))
                }
            }
            self.listener?.reasonsUpdated(reasons: self.arrayReasons)
        }
    }
    func pauseToDictionary(reason: PauseReason)->[String: Any]{
        let reasonDicto: [String : Any] = [ KeysPause.id.rawValue: reason.id,
                                            KeysPause.active.rawValue: reason.active,
                                            KeysPause.reason.rawValue: reason.reason,
                                            KeysPause.dateModification.rawValue: reason.dateModification ?? "",
                                            KeysPause.dateRegister.rawValue: reason.dateRegister ?? "",
                                            KeysPause.datePublish.rawValue: reason.datePublish ?? ""]
        return reasonDicto
    }
    
    func setListener(listener: PauseReasonsVMProtocol?){
        self.listener = listener
    }
    
    func getReasons(ovirrideCurrent : Bool = false) -> Bool {
        let rList = self.reasonsList
        if !ovirrideCurrent {
            if rList.count > 0 {
                self.reasonsList.removeAll()
                self.reasonsList = rList
                return true
            }
        }
        NetworkingServices.shared.getPauseReasons() {
            [unowned self] in
            
            if let error = $1 {
                self.reportErrorToListeners(error: error)
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.reportErrorToListeners(error: error)
                return
            }
            do {
                let decoder = JSONDecoder()
                self.reasonsList = try decoder.decode([PauseReason].self, from: data)
                self.listener?.finishLoadReasons()
            } catch let error {
                self.reportErrorToListeners(error: error)
            }
        }
        return false
    }
    
    func reportErrorToListeners(error: Error){
        self.listener?.finishWithErrorReasons(error: error)
    }
}
