//
//  BreachStorage.swift
//  Supervisores
//
//  Created by Sharepoint on 01/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData

@objc(ModuleStorage)
public class BreachStorage: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreachStorage> {
        return NSFetchRequest<BreachStorage>(entityName: "BreachStored")
    }
    @NSManaged public var id: Int
    @NSManaged public var breach : String
    @NSManaged public var breachLevel: String
    @NSManaged public var breachSelected: Bool
    @NSManaged public var breachDate : Date
}
