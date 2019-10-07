//
//  Todo+CoreDataClass.swift
//  Tod2
//
//  Created by Maurice on 10/7/19.
//  Copyright © 2019 maurice. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {
    
    convenience init?(completed:Bool, dateCreated:String?, deadline:String?, title:String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Todo.entity(), insertInto: context)
        self.completed = completed
        self.dateCreated = dateCreated
        self.deadline = deadline
        self.title = title
    }

}
