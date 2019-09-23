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
    
    // getting the file path of the sqlite file
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
    
    func getTimeNow() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formattedDate = format.string(from: date)
        let realDate = format.date(from: formattedDate)!
        
        return formattedDate
    }

    
	
}

