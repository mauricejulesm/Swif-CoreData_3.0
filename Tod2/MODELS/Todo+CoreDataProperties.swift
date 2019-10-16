//
//  Todo+CoreDataProperties.swift
//  Tod2
//
//  Created by falcon on 10/16/19.
//  Copyright © 2019 maurice. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var dateCreated: String?
    @NSManaged public var deadline: String?
    @NSManaged public var isExpanded: Bool
    @NSManaged public var title: String?
    @NSManaged public var project: Project?
    @NSManaged public var rawSubTodos: NSOrderedSet?

}

// MARK: Generated accessors for rawSubTodos
extension Todo {

    @objc(insertObject:inRawSubTodosAtIndex:)
    @NSManaged public func insertIntoRawSubTodos(_ value: Todo, at idx: Int)

    @objc(removeObjectFromRawSubTodosAtIndex:)
    @NSManaged public func removeFromRawSubTodos(at idx: Int)

    @objc(insertRawSubTodos:atIndexes:)
    @NSManaged public func insertIntoRawSubTodos(_ values: [Todo], at indexes: NSIndexSet)

    @objc(removeRawSubTodosAtIndexes:)
    @NSManaged public func removeFromRawSubTodos(at indexes: NSIndexSet)

    @objc(replaceObjectInRawSubTodosAtIndex:withObject:)
    @NSManaged public func replaceRawSubTodos(at idx: Int, with value: Todo)

    @objc(replaceRawSubTodosAtIndexes:withRawSubTodos:)
    @NSManaged public func replaceRawSubTodos(at indexes: NSIndexSet, with values: [Todo])

    @objc(addRawSubTodosObject:)
    @NSManaged public func addToRawSubTodos(_ value: Todo)

    @objc(removeRawSubTodosObject:)
    @NSManaged public func removeFromRawSubTodos(_ value: Todo)

    @objc(addRawSubTodos:)
    @NSManaged public func addToRawSubTodos(_ values: NSOrderedSet)

    @objc(removeRawSubTodos:)
    @NSManaged public func removeFromRawSubTodos(_ values: NSOrderedSet)

}
