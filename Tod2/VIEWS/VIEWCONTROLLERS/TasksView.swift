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
	
	// MARK: - Outlets
    @IBOutlet weak var todoSearchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
	@IBOutlet weak var tableView: UITableView!
    
    // MARK: - Todos arrays
    var todoItems  = [Todo]()
    var completedTodos = [Todo]()
    var incompleteTodos = [Todo]()
    var currentTodos = [Todo]()
	var unSortedTodos = [Todo]()
	var subTasks = [Todo]()

    // MARK: - Other properties
    var forSubTask = false
    var tappedCellTag = 0
	var editMode = false
    var hasLoaded = false
    
	var currentProject : Project?

	lazy var dataManager = DataManager()
	lazy var notifManager = NotificationManager()

  	// MARK: - Setting up view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentProject!.name! + " Tasks"
        
        //setup the customcell
        let nibName = UINib(nibName: "TodoCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TodoCell")

		// subtasks cell
		let nibName2 = UINib(nibName: "ProjectCell", bundle: nil)
		tableView.register(nibName2, forCellReuseIdentifier: "ProjectCell")
		
		self.hideKeyboardOnScreenTap()
        todoSearchBar.delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnTapped))
        self.navigationItem.rightBarButtonItem  = editBtn
        
        hasLoaded = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
		reclineCellsOnLoad()
		
        hasLoaded = true
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
	
	func reclineCellsOnLoad()  {
		for todo in currentTodos {
			todo.isExpanded = false
		}
	}
	// MARK: - Table view delegate methods
	func numberOfSections(in tableView: UITableView) -> Int {
		return currentTodos.count
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if (currentTodos[section].isExpanded == true) {
			return currentTodos[section].subTodos!.count + 1
		}else{
			return 1
		}
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if (indexPath.row == 0) {
			let todo = currentTodos[indexPath.section]
			let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell",for: indexPath) as! TodoCell
			
			cell.titleLabel.text = todo.title
			cell.dateCreatedLbl.text = todo.dateCreated
			cell.deadLineLabel.text = todo.deadline
            cell.addSubTaskBtn.tag = indexPath.section
            cell.addSubTaskBtn.addTarget(self, action: #selector(addSubTaskTapped(sender:)), for: .touchUpInside)
            
            if(!todo.isExpanded || editMode){
                cell.addSubTaskBtn.isHidden = true
            }else {
                cell.addSubTaskBtn.isHidden = false
            }
			let isComplete = todo.value(forKey: "completed") as! Bool

			let swicthView = UISwitch(frame: .zero)
			isComplete ? swicthView.setOn(true, animated: true) : swicthView.setOn(false, animated: true)
			swicthView.tag = indexPath.row
			swicthView.accessibilityLabel = todo.value(forKey: "title") as? String
			swicthView.addTarget(self, action: #selector(self.onTodoStatusChanged(_:)), for: .valueChanged)
			
			cell.accessoryView = swicthView
            cell.backgroundColor = editMode == true ? .lightGray : .white
			
			
			cell.viewDetails.tag = indexPath.section
			cell.viewDetails.addTarget(self, action: #selector(showTodoDetails(sender:)), for: .touchUpInside)
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell",for: indexPath) as! ProjectCell
			
            if (currentTodos[indexPath.section].subTodos?.count != 0) {
                let todo = currentTodos[indexPath.section].subTodos?[indexPath.row - 1]
                cell.projectInitialLbl.text = ""
                cell.titleLabel .text = todo?.title
                cell.dateCreatedLbl.text = "Created: Oct 14, 2019"
            }
			return cell
		}
    }
	
	@objc func showTodoDetails(sender: UIButton){
		let detailsView = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetails") as! TaskDetails
		detailsView.currentTodo = currentTodos[sender.tag]
		self.navigationController?.pushViewController(detailsView, animated: true)
	}
	
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            if (indexPath.row != 0){
                context.delete((currentTodos[indexPath.section].subTodos![indexPath.row - 1]))
                subTasks.remove(at: indexPath.row - 1)
            }else {
                context.delete(currentTodos[indexPath.section])
                
                if (segmentController.selectedSegmentIndex == 0){
                    incompleteTodos.remove(at: indexPath.section)
                }else{
                    completedTodos.remove(at: indexPath.section)
                }
                
                currentTodos.remove(at: indexPath.section)

            }
            
            do {
                try context.save()
            } catch {
                print("Error occured deleting todo")
            }
			notifManager.removeTaskNotification()
            tableView.reloadData()
        }
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if (!editMode) {
			subTasks = currentTodos[indexPath.section].subTodos!
			if currentTodos[indexPath.section].isExpanded == true{
				currentTodos[indexPath.section].isExpanded = false
				
				let sections = IndexSet.init(integer: indexPath.section)
				tableView.reloadSections(sections, with: .none)
			}else {
				currentTodos[indexPath.section].isExpanded = true
				
				let sections = IndexSet.init(integer: indexPath.section)
				tableView.reloadSections(sections, with: .none)
			}
			
		}else{
			performSegue(withIdentifier: "addNewTodo", sender: self)
		}
	}
	
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
//        if (!hasLoaded) {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 70, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.75) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
//        }
		
	}
	
	// MARK: - Searchbar and Searching
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredArray = [Todo]()
        
        if searchText != "" {
            filteredArray = currentTodos.filter() { ($0.title?.lowercased()
                .contains(searchText.lowercased()))!}
            currentTodos = filteredArray
        }else{
            currentTodos = segmentController.selectedSegmentIndex == 0 ? incompleteTodos : completedTodos
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
	
	// MARK: - Segments and status changing
    @IBAction func switchSegments(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0  {
            currentTodos = incompleteTodos
        }else{
            currentTodos = completedTodos
        }
        self.tableView.reloadData()
    }
	
    @objc func onTodoStatusChanged(_ sender: UISwitch!) {
        let currentTodoTitle = sender.accessibilityLabel
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { // Change `2.0` to the desired number of seconds.
			// Code you want to be delayed
			
			self.dataManager.updateTodoStatus(title:currentTodoTitle!)
			
			self.currentTodos.remove(at: sender.tag)
			self.assignTodos()
			
			self.tableView.reloadData()
			print("The switch is \(sender.isOn ? "ON" : "OFF")")
		}
		
    }
	
	// MARK: - Nofitications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
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
        
        let destinationVC = segue.destination as! NewTaskView
        
        let selecteRow = self.tableView.indexPathForSelectedRow?.section
    
        if (editMode){
            destinationVC.editMode = true
            destinationVC.currentTodo = currentTodos[selecteRow!]
        } else {
            if (forSubTask) {
                destinationVC.currentTodo = currentTodos[tappedCellTag]
                destinationVC.forSubTask = true
            }
        }
        destinationVC.currentNewTaskProject = currentProject
    }
	
	// MARK: - Helper functions
    @objc func editBtnTapped() {
        self.editMode = true
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem  = doneBtn
        
        tableView.reloadData()
        print("Edit mode : \(editMode)")
    }
    
    @objc func doneEditing(){
        self.editMode = false
        
        // add a done btn
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnTapped))
        self.navigationItem.rightBarButtonItem  = editBtn
        
        tableView.reloadData()
        print("Edit mode : \(editMode)")
    }
    
    @IBAction func addNewTaskTapped(_ sender: Any) {
		if !editMode {
            self.forSubTask = false
			performSegue(withIdentifier: "addNewTodo", sender: self)
		}
    }
    
    
    @objc func addSubTaskTapped(sender: UIButton) {
        self.forSubTask = true
        let btnTag = sender.tag
        tappedCellTag = btnTag
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
    func openDetailsView(todoTitle:String) {
        let secondVC = TaskDetails()
        
        secondVC.currentTodo = currentTodos[0]
        
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}
// MARK: - UIVIEW extentions
extension UIViewController {
	
    func hideKeyboardOnScreenTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
   
    
    // help dismissing the keyboard on tapping around
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
