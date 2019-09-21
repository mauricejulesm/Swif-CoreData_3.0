//
//  TodoDataManager.swift
//  Tod2
//
//  Created by falcon on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//
import UIKit
import CoreData

class TodoDataManager: NSObject {

	// todos array
	var todoItems:[NSManagedObject] = []
	
	
	func fetchTodos() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		do {
			todoItems = try context.fetch(fetchRequest)
		} catch {
			print("Error occured while fething data")
		}
	}
	
	
}
