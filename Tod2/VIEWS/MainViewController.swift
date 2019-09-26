//
//  SegmentedViewController.swift
//  Tod2
//
//  Created by falcon on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var todoSearchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    // todos tableview
    @IBOutlet weak var tableView: UITableView!
    
	
	//lazy var firstView = FirstView()

	lazy var todoManager = TodoDataManager()
    var completedTodos = [NSManagedObject]()
    var incompleteTodos = [NSManagedObject]()
    var currentTodos = [NSManagedObject]()


	override func viewDidLoad() {
		super.viewDidLoad()
        
        //setup the customcell
        let nibName = UINib(nibName: "TodoCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TodoCell")
        self.hideKeyboardOnScreenTap()
        todoSearchBar.delegate = self
    }
	
	@IBAction func switchSegments(_ sender: UISegmentedControl){
		if sender.selectedSegmentIndex == 0  {
			currentTodos = completedTodos
		}else{
			currentTodos = incompleteTodos
		}
        self.tableView.reloadData()
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // loading data from storage on app start
        todoManager.fetchTodos()
        
        // on the first load before view is switched
        assignTodos()
        currentTodos = completedTodos
        
    }
    
    func assignTodos() {
        completedTodos = []
        incompleteTodos = []
        
        for todo in todoManager.todoItems {
            if (todo.value(forKey: "completed") as! Bool == true){
                completedTodos.append(todo)
            }else{
                incompleteTodos.append(todo)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = currentTodos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell",for: indexPath) as! TodoCell
        
        cell.titleLabel.text = todo.value(forKey: "title") as? String
        cell.dateCreatedLbl.text = todo.value(forKey: "dateCreated") as? String
        cell.deadLineLabel.text = todo.value(forKey: "deadline") as? String
        
        cell.todoStatusDidChange(self)
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
            
            context.delete(currentTodos[indexPath.row])
            currentTodos.remove(at: indexPath.row)
            
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
                currentTodos = try context.fetch(fetchRequest) as! [NSManagedObject]
            }catch{
                print("could not search the todo")
            }
            
        }else{
            todoManager.fetchTodos()
            assignTodos()
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
	
	@IBAction func addTodoBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "NewTodo", sender: self)
	}
	
    @objc func registerLocal() {
        
    }
	
}
extension UIViewController {
    func hideKeyboardOnScreenTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
