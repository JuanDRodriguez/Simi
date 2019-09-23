//
//  ActionsViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 03/04/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysActions: String {
    case id = "actionId"
    case name = "actionName"
    case type = "actionType"
    case active = "actionActive"
}

@objc protocol ActionsVMProtocol {
    func getActionsError(error: Error)
    func getActions(actions: [[String: Any]])
}

class ActionsViewModel {
    static let shared = ActionsViewModel()
    var actions : [Actions] = []
    var listener: ActionsVMProtocol?
    var actionType = "S"
    init() { }
    
    func setListener(listener: ActionsVMProtocol?) {
        self.listener = listener
    }
    
    func getActions(type: String) {
        self.actionType = type
        if self.actions.count > 0{
            self.listener?.getActions(actions: self.actionsToArray())
            return
        }
        NetworkingServices.shared.getActions() {
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
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
               // print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError.localizedDescription)
            }
            do {
                let decoder = JSONDecoder()
                self.actions = try decoder.decode([Actions].self, from: data)
                self.listener?.getActions(actions: self.actionsToArray())
            } catch let error {
                self.reportErrorToListeners(error: error)
            }
        }
    }
    
    func actionsToArray()->[[String: Any]] {
        var arrayActions : [[String : Any]] = []
        for action in self.actions {
            if action.active && self.actionType == action.typeAction {
                let dicto : [String: Any] = [KeysActions.id.rawValue: action.actionId,
                                             KeysActions.name.rawValue: action.name]
                arrayActions.append(dicto)
            }
        }
        return arrayActions
    }
    
    func reportErrorToListeners(error: Error) {
        self.listener?.getActionsError(error: error)
    }
}
