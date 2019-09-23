//
//  QuestionStorage.swift
//  Supervisores
//
//  Created by Sharepoint on 01/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData

@objc(ModuleStorage)
public class QuestionStorage: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionStorage> {
        return NSFetchRequest<QuestionStorage>(entityName: "QuestionStored")
    }
    @NSManaged public var id: Int
    @NSManaged public var active: Bool
    @NSManaged public var topic : String
    @NSManaged public var type: String
    @NSManaged public var dateSolution : Bool
    @NSManaged public var question: String
    @NSManaged public var order: Int
    @NSManaged public var topicId: Int
    @NSManaged public var typeId: Int
    @NSManaged public var comment: Bool
    @NSManaged public var commentForced: Bool
    @NSManaged public var photo: Bool
    @NSManaged public var photoForced: Bool
    @NSManaged public var moduleId: Int
    @NSManaged public var action: Bool
    @NSManaged public var legend: String
    
    //    @objc(addCarsObject:)
    //    @NSManaged public func addToCars(_ value: Car)
    //
    //    @objc(removeCarsObject:)
    //    @NSManaged public func removeFromCars(_ value: Car)
    //
    //    @objc(addCars:)
    //    @NSManaged public func addToCars(_ values: NSSet)
    //
    //    @objc(removeCars:)
    //    @NSManaged public func removeFromCars(_ values: NSSet
}
