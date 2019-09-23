//
//  Supervision+ModulesVM.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

extension SupervisionViewController: SupervisionModulesVMProtocol, PickerSelectViewDelegate, PauseReasonsVMProtocol {
    func modulesUpdated(modules: [[String : Any]]) {
        DispatchQueue.main.async {
            self.modulesList.removeAll()
            guard let unitType = self.unitInfo[KeysSupervision.unitType.rawValue] as? String else {return}
            if unitType == KeysUnitType.branchOffice.rawValue {
                self.modulesList = modules.filter({
                    guard let type = $0[KeysModule.type.rawValue] as? String else {return false}
                    return type == "S"
                })
                self.checkModulesFilter()
                self.checkSupervisionFinish()
            } else {
                self.modulesList = modules.filter({
                    guard let type = $0[KeysModule.type.rawValue] as? String else {return false}
                    return type == "F"
                })
                self.checkModulesFilter()
                self.checkSupervisionFinish()
            }
            self.categoryList.reloadData()
        }
    }
    func checkModulesFilter(){
        
    }
    func finishWithError(error: Error) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.lottieView?.animationFinishError()
        }
    }
    func finishLoadModules() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.lottieView?.animationFinishCorrect()
        }
    }
    func selectOption(_ option: Int, value: String) {
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
        let pauseOpt = self.pauseReasons[option]
        guard let idPause = pauseOpt[KeysPause.id.rawValue] as? Int else {return}
        guard let descPause = pauseOpt[KeysPause.reason.rawValue] as? String else {return}
        Storage.shared.saveNewPause(idReason: idPause, descReason: descPause)
        
        let savePauseRemotly: SavePauseRemotly = SavePause.shared
      savePauseRemotly.savePauseInServer()
        
        self.dismiss(animated: true, completion: nil)
    }
    func dissmisVC(){
        self.dissmisOnEnter = true
    }
    func cancelOption() {
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
    }
    func reasonsUpdated(reasons: [[String : Any]]) {
        self.pauseReasons = reasons
        DispatchQueue.main.async {
            let str: [String] = reasons.map({
                return $0[KeysPause.reason.rawValue] as! String
            })
            self.pickerView!.updateOptions(options: str)
            if self.loadingReasons {
                self.loadingReasons = false
                self.lottieView?.animationFinishCorrect()
                guard let pickerView = self.pickerView else {
                    return
                }
                self.view.addSubview(pickerView)
            }
        }
    }
    func finishWithErrorReasons(error: Error){
        if self.loadingReasons {
            DispatchQueue.main.async {
                self.lottieView?.animationFinishError()
            }
        }
    }
    func finishLoadReasons() {
        if self.loadingReasons {
            DispatchQueue.main.async {
                self.lottieView?.animationFinishCorrect()
            }
        }
    }
}
