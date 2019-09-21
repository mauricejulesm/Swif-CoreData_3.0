//
//  ViewController.swift
//  Tod2
//
//  Created by falcon on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import CoreData

class FirstView: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {
	@IBOutlet weak var todoSearchBar: UISearchBar!
	
	// todos tableview
	@IBOutlet weak var tableView: UITableView!
	
	// todos array
	//var todoItems:[NSManagedObject] = []
	
	lazy var todoManager = TodoDataManager()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//setup the customcell
		let nibName = UINib(nibName: "TodoCell", bundle: nil)
		tableView.register(nibName, forCellReuseIdentifier: "TodoCell")
		
		todoSearchBar.delegate = self
		
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		NotificationCenter.default.addObserver(self, selector: #selector(loadTodos), name: NSNotification.Name(rawValue: "load"), object: nil)

		// loading data from storage on app start
	   todoManager.fetchTodos()
	}
	
	@objc func loadTodos(notification: NSNotification){
		//load data here
		todoManager.fetchTodos()
		self.tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoManager.todoItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let todo = todoManager.todoItems[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell",for: indexPath) as! TodoCell

		cell.titleLabel.text = todo.value(forKey: "title") as? String
		cell.deadLineLabel.text = "Sep 12, 2019"

		return cell
	}
	
	// allow delete option
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
			
			context.delete(todoManager.todoItems[indexPath.row])
			todoManager.todoItems.remove(at: indexPath.row)
			
			do {
				try context.save()
			} catch {
				print("Error occured deleting todo")
			}
			self.tableView.reloadData()
			
		}
	}
	
	
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText != "" {
			var predicate:NSPredicate = NSPredicate()
			predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
			
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
			
			fetchRequest.predicate = predicate
			
			do{
				todoManager.todoItems = try context.fetch(fetchRequest) as! [NSManagedObject]
			}catch{
				print("could not search the todo")
			}
			
		}else{
			todoManager.fetchTodos()
			self.tableView.reloadData()
		}
		self.tableView.reloadData()
	}
}

