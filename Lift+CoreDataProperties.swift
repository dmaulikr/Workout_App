//
//  Lift+CoreDataProperties.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 23/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
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
