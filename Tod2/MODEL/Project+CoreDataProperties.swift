//
//  Project+CoreDataProperties.swift
//  Tod2
//
//  Created by Maurice on 10/3/19.
//  Copyright © 2019 maurice. All rights reserved.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var name: String
    @NSManaged public var dateProjCreated: String
    @NSManaged public var todos: NSSet

}

// MARK: Generated accessors for todos
extension Project {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Todo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Todo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
