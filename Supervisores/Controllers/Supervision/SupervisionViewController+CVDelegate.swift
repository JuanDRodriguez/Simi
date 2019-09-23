//
//  SupervisionViewController+CVDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 05/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension SupervisionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SupervisionListDelegate {
    func countBreaches(count: Int) {
        self.countNewBreaches = count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cornerRadius, height: self.cornerRadius + 34)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let module = self.modulesList[indexPath.row]
        let questionListVC = SupervisionListFormViewController()
        questionListVC.delegate = self
        questionListVC.typeStore = self.TypeStore
        questionListVC.setModule(module: module)
        questionListVC.countNewBreaches = self.countNewBreaches 
        if let titulonav = unitInfo[KeysSupervision.typeOperation.rawValue] as? String {
            if titulonav == KeysOperation.visit.rawValue {
                navBarVC?.setTitle(newTitle:"Visita")// \(unitName)")
            } else {
                navBarVC?.setTitle(newTitle:"Supervisión")// \(unitName)")
            }
        } else {
            navBarVC?.setTitle(newTitle:"Supervisión")// \(unitName)")
        }
        questionListVC.isEditingSupervision = self.isEditingSupervision
        for i in 0 ..< self.modulesFilter.count {
            if module[KeysModule.id.rawValue] as! Int == self.modulesFilter[i]{
                questionListVC.isEditingSupervision = self.isEditingSupervision
                 questionListVC.isEditingQuestion = true
            }else{
               questionListVC.isEditingSupervision = self.isEditingSupervision
                questionListVC.isEditingQuestion = self.isEditingSupervision
            }
        }
        
        CurrentSupervision.shared.setCurrentModule(module: module)
        self.present(questionListVC, animated: true, completion: nil)
    }
    func updatePercent(idModule: Int, currentQuestion: Int, percent: Int) {
        self.modulesList = self.modulesList.map({module in
            guard let idModuleMapped = module[KeysModule.id.rawValue] as? Int else {return module}
            if idModuleMapped == idModule {
                var mod = module
                mod[KeysModule.percentFinish.rawValue] = percent
                mod[KeysModule.currentQuestion.rawValue] = currentQuestion
                return mod
            }
            return module
        })
        self.checkSupervisionFinish()
    }
    func newSupervisionFromAddBreaches(){
        self.isEditingSupervision = false
        let _ = SupervisionModulesViewModel.shared.getModules(ovirrideCurrent: false)
        self.checkSupervisionFinish()
    }
}
