//
//  TodosViewController.swift
//  Tod2
//
//  Created by falcon on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import UserNotifications

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var todoSearchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    // todos tableview
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentProject : Project?
    
    // todos array
    var todoItems : [Todo] = []
    var completedTodos = [Todo]()
    var incompleteTodos = [Todo]()
    var currentTodos = [Todo]()
    
    // todo manager instance
    lazy var todosManager = DataManager()
    
    var unSortedTodos : [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentProject!.name! + "Tasks"
        // todos of a project
        // currentProject = todosManager.currentProject
        
        //setup the customcell
        let nibName = UINib(nibName: "TodoCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TodoCell")
        //tableView.rowHeight = UITableView.automaticDimension
        self.hideKeyboardOnScreenTap()
        todoSearchBar.delegate = self
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // loading data from storage on app start
        //todosManager.fetchTodos()
        
        // on the first load before view is switched
        unSortedTodos = (currentProject?.todos)!
        
        
        // sort todos by date created
        todoItems = unSortedTodos.sorted(by: { (todo1, todo2) -> Bool in
            return todo1.dateCreated!.lowercased() > todo2.dateCreated!.lowercased()
        })
            
        assignTodos()
        
        // showing incomplete todos for the first run
        if (segmentController.selectedSegmentIndex == 0){
            currentTodos = incompleteTodos
        }
        self.tableView.reloadData()
    }
    
    func assignTodos() {
        completedTodos = []
        incompleteTodos = []
        
        for todo in todoItems {
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
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 250
	}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = currentTodos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell",for: indexPath) as! TodoCell
        
        // setting up the table cell
        cell.titleLabel.text = todo.value(forKey: "title") as? String
        cell.dateCreatedLbl.text = todo.value(forKey: "dateCreated") as? String
        cell.deadLineLabel.text = todo.value(forKey: "deadline") as? String
        
        let isComplete = todo.value(forKey: "completed") as! Bool
        
        let swicthView = UISwitch(frame: .zero)
        isComplete ? swicthView.setOn(true, animated: true) : swicthView.setOn(false, animated: true)
        swicthView.tag = indexPath.row
        swicthView.accessibilityLabel = todo.value(forKey: "title") as? String
        swicthView.addTarget(self, action: #selector(self.onTodoStatusChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = swicthView
        
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
            
            if (segmentController.selectedSegmentIndex == 0){
                incompleteTodos.remove(at: indexPath.row)
            }else{
                completedTodos.remove(at: indexPath.row)
            }
            do {
                try context.save()
            } catch {
                print("Error occured deleting todo")
            }
            //self.tableView.reloadData()
            currentTodos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = currentTodos[indexPath.row].value(forKey: "title") as! String
        openDetailsView(todoTitle: title)
    }
	
	// display the tableview cells with animations
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		/*
		// animation 1 [ not user friendly! ]
		let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
		cell.layer.transform = rotationTransform
		cell.alpha = 0.5
		
		
		UIView.animate(withDuration: 1.0) {
		cell.layer.transform = CATransform3DIdentity
		cell.alpha = 1.0
		}
		*/
		
		// animation 2 [ more user friendly & simpler! ]
		let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 70, 0)
		cell.layer.transform = rotationTransform
		cell.alpha = 0
		
		UIView.animate(withDuration: 0.75) {
			cell.layer.transform = CATransform3DIdentity
			cell.alpha = 1.0
		}
		
		
	}
	
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            var predicate : NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = todosManager.getTodoFetchRequest()
            
            fetchRequest.predicate = predicate
            do{
                currentTodos = try context.fetch(fetchRequest)
            }catch{
                print("could not search the todo")
            }
        }else{
            currentTodos = segmentController.selectedSegmentIndex == 0 ? incompleteTodos : completedTodos
        }
        self.tableView.reloadData()
    }
    
    @IBAction func switchSegments(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0  {
            currentTodos = incompleteTodos
        }else{
            currentTodos = completedTodos
        }
        self.tableView.reloadData()
    }
    // called when the switch is changed
    @objc func onTodoStatusChanged(_ sender: UISwitch!) {
        let currentTodoTitle = sender.accessibilityLabel
		
        // update the current todo's status
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { // Change `2.0` to the desired number of seconds.
			// Code you want to be delayed
			
			self.todosManager.updateTodoStatus(title:currentTodoTitle!)
			
			self.currentTodos.remove(at: sender.tag)
			self.assignTodos()
			
			self.tableView.reloadData()
			print("Table row switch Changed \(sender.tag) on todo \(currentTodoTitle ?? "")")
			print("The switch is \(sender.isOn ? "ON" : "OFF")")
		}
		
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "show" {
            openDetailsView(todoTitle:response.notification.request.content.body)
            
            //showToast(message: "Showing the current todo reminder u tapped!")
        }else if (response.actionIdentifier == "dismiss"){
            print("Nothing to do here")
            //showToast(message: "U chose remind me later ")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? NewTaskView else {
            return
        }
        destinationVC.project = currentProject
    }
    
    
    @IBAction func addTodoBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewTodo", sender: self)
    }
    
    // showing a simple
    func showToast(message:String) {
        let alertDisapperTimeInSeconds = 2.0
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
            alert.dismiss(animated: true)
        }
    }
    
}
extension UIViewController {
    func hideKeyboardOnScreenTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func openDetailsView(todoTitle:String) {
        let secondVC = TaskDetails()
        secondVC.todoTitle.append( todoTitle )
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    // help dismissing the keyboard on tapping around
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
