//
//  SupervisionModulesViewModel.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysModule: String {
    case id = "idModule"
    case name = "nameModule"
    case order = "orderModule"
    case type = "typeModule"
    case image = "imageModule"
    case dateRegister = "dateRegisterModule"
    case dateChange = "dateChangeModule"
    case percentFinish = "percentFinish"
    case currentQuestion = "currentQuestion"
    case active = "activeModule"
    case numberQuestions = "numberQuestions"
}

@objc protocol SupervisionModulesVMProtocol {
    func modulesUpdated(modules: [[String: Any]])
    func finishWithError(error: Error)
    func finishLoadModules()
}

class SupervisionModulesViewModel {
    static let shared = SupervisionModulesViewModel()
    var listener: SupervisionModulesVMProtocol?
    init() {
      
    }
    var modulesList: [Module] = [] {
        didSet {
            var arrayModulesMaped: [[String: Any]] = []
            let modulesSorted = modulesList.sorted(by: {$0.order < $1.order})
            for module in modulesSorted {
                if module.active && module.numberQuestions > 0 {
                    arrayModulesMaped.append(moduleToDictionary(module: module))
                }
            }
            self.listener?.modulesUpdated(modules: arrayModulesMaped)
        }
    }
    func moduleToDictionary(module: Module)->[String: Any]{
        let moduleDicto: [String : Any] = [ KeysModule.id.rawValue: module.id,
                                            KeysModule.name.rawValue: module.name,
                                            KeysModule.order.rawValue: module.order,
                                            KeysModule.image.rawValue: module.image,
                                            KeysModule.dateRegister.rawValue: module.dateRegister,
                                            KeysModule.type.rawValue: module.type,
                                            KeysModule.dateChange.rawValue: module.dateChange,
                                            KeysModule.percentFinish.rawValue: module.percentFinish,
                                            KeysModule.currentQuestion.rawValue: module.currentQuestion,
                                            KeysModule.active.rawValue: module.active,
                                            KeysModule.numberQuestions.rawValue: module.numberQuestions]
        return moduleDicto
    }

    func setListener(listener: SupervisionModulesVMProtocol?){
        self.listener = listener
    }
    
    func getModules(ovirrideCurrent : Bool = false) -> Bool {
        let modules = self.modulesList
        self.modulesList.removeAll()
        if !ovirrideCurrent {
            if modules.count > 0 {
                self.modulesList = modules
                return true
            }
            let loadFromStorage = Storage.shared.getModules()
            if loadFromStorage.count > 0 {
                self.modulesList = loadFromStorage
                return true
            }
        }
        Storage.shared.deleteModules()
        NetworkingServices.shared.getModules() {
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
                //print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError.localizedDescription)
            }
            do {
                let decoder = JSONDecoder()
                self.modulesList = try decoder.decode([Module].self, from: data)
                Storage.shared.saveModules(listModules: self.modulesList)
                self.listener?.finishLoadModules()
            } catch let error {
                self.reportErrorToListeners(error: error)
            }
        }
        return false
    }
   
    func reportErrorToListeners(error: Error){
        self.listener?.finishWithError(error: error)
    }
    
    func updateModule(idModule: Int, currentQuestion: Int, percent: Int){
        modulesList = modulesList.map({
            if $0.id == idModule {
                $0.currentQuestion = currentQuestion
                $0.percentFinish = percent
            }
            return $0
        })
        let moduleFilter = modulesList.filter({$0.id == idModule})
        if moduleFilter.count > 0 {
            Storage.shared.updateModule(module: moduleFilter[0])
        }
    }
    func resetModule(){
//        modulesList = modulesList.map({
//            $0.currentQuestion = 0
//            $0.percentFinish = 0
//            return $0
//        })
        self.modulesList.removeAll()
    }
}
