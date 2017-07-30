//
//  Exercise+CoreDataProperties.swift
//  
//
//  Created by Jordan Jacobson on 30/7/17.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var amountLifted: Float
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var repNum: String?
    @NSManaged public var setNum: String?
    @NSManaged public var workouts: NSSet?
    @NSManaged public var lifts: NSSet?

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

// MARK: Generated accessors for lifts
extension Exercise {

    @objc(addLiftsObject:)
    @NSManaged public func addToLifts(_ value: Lift)

    @objc(removeLiftsObject:)
    @NSManaged public func removeFromLifts(_ value: Lift)

    @objc(addLifts:)
    @NSManaged public func addToLifts(_ values: NSSet)

    @objc(removeLifts:)
    @NSManaged public func removeFromLifts(_ values: NSSet)

}
