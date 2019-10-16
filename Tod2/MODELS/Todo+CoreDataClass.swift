//
//  Todo+CoreDataClass.swift
//  Tod2
//
//  Created by falcon on 10/16/19.
//  Copyright © 2019 maurice. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {
	
	var subTodos: [Todo]? {
		return self.rawSubTodos?.array as? [Todo]
	}
	
	convenience init?(completed:Bool, isExpanded:Bool, dateCreated:String?, deadline:String?, title:String?) {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		
		guard let context = appDelegate?.persistentContainer.viewContext else {
			return nil
		}
		self.init(entity: Todo.entity(), insertInto: context)
		self.isExpanded = isExpanded
		self.completed = completed
		self.dateCreated = dateCreated
		self.deadline = deadline
		self.title = title
	}
	
	
	
}
