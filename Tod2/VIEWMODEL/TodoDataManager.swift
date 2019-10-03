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
	var todoItems = [Todo]()
    var completedTodos = [Todo]()
    var incompleteTodos = [Todo]()
    var currentTodos = [Todo]()
    
	
	func fetchTodos() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = getTodoFetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
		do {
            todoItems = try context.fetch(fetchRequest) as! [Todo]
		} catch {
			print("Error occured while fething data")
		}
	}
    
    func updateTodoStatus(title:String) {
        let isComplete: Bool

        // update the current todo in the coredata store
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "title = %@", "\(title)")
        do{
            let test = try context.fetch(fetchRequest)
            let todoToUpdate = test[0] as! NSManagedObject
            isComplete = todoToUpdate.value(forKey: "completed") as! Bool

            isComplete ? todoToUpdate.setValue(false, forKey: "completed") : todoToUpdate.setValue(true, forKey: "completed")

            try context.save()
        }catch{
            print(error)
        }
        
        print("Object: \(title) updated")
    }
    
    func saveNewTodo(title: String, deadline: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)!
        let todo = NSManagedObject(entity: entity, insertInto: context)
        let date = "Created: " + self.getTimeNow()
        let due = "Due: " + deadline
        let completed = false
        
        
        todo.setValue(title, forKey: "title")
        todo.setValue(date, forKey: "dateCreated")
        todo.setValue(due, forKey: "deadline")
        todo.setValue(completed, forKey: "completed")
        
        do {
            try context.save()
            todoItems.append(todo as! Todo)
        } catch {
            print("Error occured while saving new todo (error.localizedDescription)")
        }
        
    }
    
    // get the fetchRequest
    func getTodoFetchRequest() -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        return fetchRequest
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
        //let realDate = format.date(from: formattedDate)!
        
        return formattedDate
    }

    
	
}

