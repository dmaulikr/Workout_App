//
//  Lift+CoreDataProperties.swift
//  
//
//  Created by Jordan Jacobson on 30/7/17.
//
//

import Foundation
import CoreData


extension Lift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lift> {
        return NSFetchRequest<Lift>(entityName: "Lift")
    }

    @NSManaged public var lifted: Int16
    @NSManaged public var exercise: Exercise?
    @NSManaged public var session: Session?

}
