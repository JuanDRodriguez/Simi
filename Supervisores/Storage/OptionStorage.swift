//
//  OptionStorage.swift
//  Supervisores
//
//  Created by Sharepoint on 01/03/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import CoreData

@objc(ModuleStorage)
public class OptionStorage: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OptionStorage> {
        return NSFetchRequest<OptionStorage>(entityName: "OptionStored")
    }
    @NSManaged public var id: Int
    @NSManaged public var option : String
    @NSManaged public var weighing: Int
    @NSManaged public var breach: Bool
    @NSManaged public var dateSolution : Bool
    @NSManaged public var breachLevel: Bool
    @NSManaged public var subOption : Bool
    @NSManaged public var mail : Bool
    @NSManaged public var optionMail : Data
        
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
