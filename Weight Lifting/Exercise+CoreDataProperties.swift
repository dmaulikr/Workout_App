//
//  Exercise+CoreDataProperties.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 15/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var repNum: String?
    @NSManaged public var setNum: String?
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for workouts
extension Exercise {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}
