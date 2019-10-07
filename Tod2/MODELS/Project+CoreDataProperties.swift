//
//  Project+CoreDataProperties.swift
//  Tod2
//
//  Created by Maurice on 10/7/19.
//  Copyright © 2019 maurice. All rights reserved.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var dateProjCreated: String?
    @NSManaged public var name: String?
    @NSManaged public var rawTodos: NSOrderedSet?

}

// MARK: Generated accessors for rawTodos
extension Project {

    @objc(insertObject:inRawTodosAtIndex:)
    @NSManaged public func insertIntoRawTodos(_ value: Todo, at idx: Int)

    @objc(removeObjectFromRawTodosAtIndex:)
    @NSManaged public func removeFromRawTodos(at idx: Int)

    @objc(insertRawTodos:atIndexes:)
    @NSManaged public func insertIntoRawTodos(_ values: [Todo], at indexes: NSIndexSet)

    @objc(removeRawTodosAtIndexes:)
    @NSManaged public func removeFromRawTodos(at indexes: NSIndexSet)

    @objc(replaceObjectInRawTodosAtIndex:withObject:)
    @NSManaged public func replaceRawTodos(at idx: Int, with value: Todo)

    @objc(replaceRawTodosAtIndexes:withRawTodos:)
    @NSManaged public func replaceRawTodos(at indexes: NSIndexSet, with values: [Todo])

    @objc(addRawTodosObject:)
    @NSManaged public func addToRawTodos(_ value: Todo)

    @objc(removeRawTodosObject:)
    @NSManaged public func removeFromRawTodos(_ value: Todo)

    @objc(addRawTodos:)
    @NSManaged public func addToRawTodos(_ values: NSOrderedSet)

    @objc(removeRawTodos:)
    @NSManaged public func removeFromRawTodos(_ values: NSOrderedSet)

}
