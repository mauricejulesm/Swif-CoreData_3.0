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
	var unSortedTodos : [Todo] = []
    
    var forSubTask = false
    
    var tappedCellTag = 0

    // todo manager instance
    lazy var dataManager = DataManager()
	
	var subTasks = [Todo]()
	
    // monitor edit mode
    var editMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentProject!.name! + " Tasks"
		
		//subTasks = (currentProject?.todos![0].subTodos)!
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // loading data from storage on app start
        //dataManager.fetchTodos()
        
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
			
			// setting up the table cell
			cell.titleLabel.text = todo.title
			cell.dateCreatedLbl.text = todo.dateCreated
			cell.deadLineLabel.text = todo.deadline
			
            cell.addSubTaskBtn.tag = indexPath.section
            cell.addSubTaskBtn.addTarget(self, action: #selector(addSubTaskTapped(sender:)), for: .touchUpInside)
            
            if(!todo.isExpanded){
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
            
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell",for: indexPath) as! ProjectCell
            
            if (currentTodos[indexPath.section].subTodos?.count != 0) {
                cell.dateCreatedLbl.text = "Created: Oct 14, 2019"
                let todo = currentTodos[indexPath.section].subTodos?[0]
                cell.projectInitialLbl.text = ""
                cell.titleLabel .text = todo?.title
                cell.dateCreatedLbl.text = "Created: Oct 14, 2019"
                
            }
			return cell
		}
    }
    
    // allow delete option
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(currentTodos[indexPath.section])
            
            if (segmentController.selectedSegmentIndex == 0){
                incompleteTodos.remove(at: indexPath.section)
            }else{
                completedTodos.remove(at: indexPath.section)
            }
            do {
                try context.save()
            } catch {
                print("Error occured deleting todo")
            }
            //self.tableView.reloadData()
            currentTodos.remove(at: indexPath.section)
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
			
			self.dataManager.updateTodoStatus(title:currentTodoTitle!)
			
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
    }
    
    @objc func editBtnTapped() {
        self.editMode = true
        
        // add a done btn
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
        performSegue(withIdentifier: "addNewTodo", sender: self)
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
