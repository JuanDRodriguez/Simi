//
//  PastSupervisionViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 5/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

protocol PastSupervisionVMProtocol {
    func getPastSupervision(supervisors: [[String: Any]], franchise: [[String: Any]])
    func getPastSupervisionError()
}

enum KeysPastSupervision: String {
    case supervisionId = "keysSupervisionId"
    case dateBegin = "keysDateBegin"
    case dateEnd = "keysDateEnd"
    case numberBreaches = "keysNumberBreaches"
    case isVisit = "keysIsVisit"
    case isNocturne = "keysIsNocturne"
    case numberStars = "keysNumberStars"
    case userId = "keysUserId"
    case domainAccount = "keysDomainAccount"
    case isActive = "keysIsActive"
    case profile = "keysProfile"
    case profileId = "keysProfileId"
}

class PastSupervisionViewModel {
    static let shared = PastSupervisionViewModel()
    var listener: PastSupervisionVMProtocol?
    var ultimeSupervision: [PastSupervision] = []
    var lastSupervisions: [PastSupervision] = [] {
        didSet {
            var arrSupervisors : [[String: Any]] = []
            var arrFranchise : [[String: Any]] = []
            for pastSup in self.lastSupervisions {
                let arr = self.pastSupervisionToDictionary(pastSup: pastSup)
                if let profile = pastSup.user?.profileId {
                    if profile == .franchisee {
                        arrFranchise.append(arr)
                    } else {
                        arrSupervisors.append(arr)
                    }
                }
            }
            self.listener?.getPastSupervision(supervisors: arrSupervisors, franchise: arrFranchise)
        }
    }
    
    func pastSupervisionToDictionary(pastSup: PastSupervision)->([String: Any]) {
        let psSuperDicto: [String : Any] = [ KeysPastSupervision.supervisionId.rawValue: pastSup.supervisionId,
                                             KeysPastSupervision.dateBegin.rawValue: pastSup.dateBegin ?? Date(),
                                             KeysPastSupervision.dateEnd.rawValue: pastSup.dateEnd ?? Date(),
                                             KeysPastSupervision.numberBreaches.rawValue: pastSup.numberBreach,
                                             KeysPastSupervision.isVisit.rawValue: pastSup.isVisit,
                                             KeysPastSupervision.isNocturne.rawValue: pastSup.isNocturne,
                                             KeysPastSupervision.numberStars.rawValue: pastSup.numberStars,
                                             KeysPastSupervision.userId.rawValue: pastSup.user?.userId ?? -1,
                                             KeysPastSupervision.domainAccount.rawValue: pastSup.user?.domainAccount ?? "",
                                             KeysPastSupervision.isActive.rawValue: pastSup.user?.active ?? false,
                                             KeysPastSupervision.profile.rawValue: pastSup.user?.profile ?? "",
                                             KeysPastSupervision.profileId.rawValue: pastSup.user?.profileId ?? Profiles.general]
        return psSuperDicto
    }
   
    init() { }
    
    func setListener(listener: PastSupervisionVMProtocol?){
        self.listener = listener
    }
    
    func getSupervisionByUnit(unitId: Int) {
        NetworkingServices.shared.getSupervisionByUnit(unitId: unitId) {
            [unowned self] in
            if let _ = $1 {
                self.listener?.getPastSupervisionError()
            }
            guard let data = $0 else {
                self.listener?.getPastSupervisionError()
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
              print("datResponse:\(jsonResponse)") //Response result
            } catch let parsingError {
                
                print("Error", parsingError.localizedDescription)
            }
            do {
                let decoder = JSONDecoder()
                self.lastSupervisions = try decoder.decode([PastSupervision].self, from: data)
                
                
            } catch {
                self.listener?.getPastSupervisionError()
            }
        }
    }
}
