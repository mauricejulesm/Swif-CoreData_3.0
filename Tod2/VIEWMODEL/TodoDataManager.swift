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
    
    func updateTodoStatus(title:String) {
        let isComplete: Bool

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
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

