//
//  CurrentSupervision.swift
//  Supervisores
//
//  Created by Sharepoint on 18/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

class CurrentSupervision {
    static let shared = CurrentSupervision()
    private var currentUnit: [String: Any] = [:]
    private var currentModule: [String: Any] = [:]
    private var editingSupervisionLimit = false
    
    func setCurrentUnit(unit: [String: Any]) {
        self.currentUnit = unit
    }
    
    func getCurrentUnit()->[String: Any]{
        return currentUnit
    }
    
    func setCurrentModule(module: [String: Any]) {
        self.currentModule = module
    }
    
    func getCurrentModule()->[String: Any]{
        return currentModule
    }
    func setEditingSupervisionLimit(isOnLimit: Bool) {
        self.editingSupervisionLimit = isOnLimit
    }
    func isEditingOnLimit()->Bool {
        return self.editingSupervisionLimit
    }
}
