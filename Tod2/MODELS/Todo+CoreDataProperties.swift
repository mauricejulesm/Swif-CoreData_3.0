//
//  Todo+CoreDataProperties.swift
//  Tod2
//
//  Created by falcon on 10/13/19.
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
    @NSManaged public var isExpanded: Bool
    @NSManaged public var project: Project?

}
