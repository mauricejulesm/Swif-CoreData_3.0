//
//  Todo+CoreDataProperties.swift
//  Tod2
//
//  Created by Maurice on 10/7/19.
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
    @NSManaged public var title: String?
    @NSManaged public var project: Project?

}
