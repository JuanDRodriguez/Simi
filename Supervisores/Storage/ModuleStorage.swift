//
//  ModuleStorage.swift
//  Supervisores
//
//  Created by Sharepoint on 01/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(ModuleStorage)
public class ModuleStorage: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModuleStorage> {
        return NSFetchRequest<ModuleStorage>(entityName: "ModuleStored")
    }
    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var order: Int
    @NSManaged public var type: String
    @NSManaged public var image: UIImage
    @NSManaged public var active: Bool
    @NSManaged public var dateRegister: Date
    @NSManaged public var dateChange: Date
    @NSManaged public var percentFinish: Int
    @NSManaged public var numberQuestions: Int
    @NSManaged public var currentQuestion: Int
    
//    @objc(addQuestionsObject:)
//    @NSManaged public func addToQuestions(_ value: QuestionStorage)
//    
//    @objc(removeQuestionsObject:)
//    @NSManaged public func removeFromQuestions(_ value: QuestionStorage)
//    
//    @objc(addQuestions:)
//    @NSManaged public func addToQuestions(_ values: NSSet)
//    
//    @objc(removeQuestions:)
//    @NSManaged public func removeFromQuestions(_ values: NSSet)
}
