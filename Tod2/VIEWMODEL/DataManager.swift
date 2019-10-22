//
//  DataManager.swift
//  Tod2
//
//  Created by falcon on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//
import UIKit
import CoreData

class DataManager: NSObject {
    var projects = [Project]()
    
    func fetchProjects() -> [Project] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [Project]() }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = getProjectFetchRequest()
        let sortDesc = NSSortDescriptor(key: "dateProjCreated", ascending: false)
        fetchRequest.sortDescriptors = [sortDesc]
        
        do {
            projects = try context.fetch(fetchRequest)
        } catch  {
            print("Unable to fetch categories")
        }
        return projects
    }
    func updateTodoStatus(title:String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = getTodoFetchRequest()
        // fetchRequest.predicate = NSPredicate(format: "title = %@ AND dateCreated = %@", title, date)           // for more precision
        fetchRequest.predicate = NSPredicate(format: "title = %@", "\(title)")
        do{
            let test = try context.fetch(fetchRequest)
            let todoToUpdate = test[0]
            todoToUpdate.completed ? todoToUpdate.setValue(false, forKey: "completed") : todoToUpdate.setValue(true, forKey: "completed")
            todoToUpdate.isExpanded ? todoToUpdate.isExpanded = false : nil
            try context.save()
        }catch{
            print(error)
        }
        print("Object: \(title) updated")
    }
    
    
    func editTodo(title:String, newTodoTitle:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = getTodoFetchRequest()
        // fetchRequest.predicate = NSPredicate(format: "title = %@ AND dateCreated = %@", title, date)           // for more precision
        fetchRequest.predicate = NSPredicate(format: "title = %@", "\(title)")
        do{
            let test = try context.fetch(fetchRequest)
            let todoToUpdate = test[0]
            todoToUpdate.setValue(newTodoTitle, forKey: "title")
            try context.save()
        }catch{
            print(error)
        }
        print("Task: \(title) updated to: \(newTodoTitle)")
    }
    
    func updateProject(title:String, newTitle:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = getProjectFetchRequest()
        // fetchRequest.predicate = NSPredicate(format: "title = %@ AND dateCreated = %@", title, date)           // for more precision
        fetchRequest.predicate = NSPredicate(format: "name = %@", "\(title)")
        do{
            let project = try context.fetch(fetchRequest)
            let projectToUpdate = project[0]
            projectToUpdate.setValue(newTitle, forKey: "name")
            try context.save()
        }catch{
            print(error)
        }
        print("Project: \(title) updated to: \(newTitle) ")
    }
    
    
    // get the fetchRequest
    func getTodoFetchRequest() -> NSFetchRequest<Todo> {
        let fetchRequest : NSFetchRequest<Todo> = Todo.fetchRequest()
        return fetchRequest
    }
    
    // get the fetchRequest
    func getProjectFetchRequest() -> NSFetchRequest<Project> {
        let fetchRequest : NSFetchRequest<Project> = Project.fetchRequest()
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
        format.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
        
        let formattedDate = format.string(from: date)
        //let realDate = format.date(from: formattedDate)!
        
        return formattedDate
    }
    
    
    
}

