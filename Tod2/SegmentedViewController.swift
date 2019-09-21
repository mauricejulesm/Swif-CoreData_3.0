//
//  SegmentedViewController.swift
//  Tod2
//
//  Created by falcon on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import CoreData

class SegmentedViewController: UIViewController {

	@IBOutlet weak var firstView:UIView!
	@IBOutlet weak var secondView:UIView!
	
	//lazy var firstView = FirstView()

	lazy var todoManager = TodoDataManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	@IBAction func switchViews(_ sender: UISegmentedControl){
		if sender.selectedSegmentIndex == 0  {
			firstView.alpha = 1
			secondView.alpha = 0
		}else{
			firstView.alpha = 0
			secondView.alpha = 1
		}
	}
	
	var titleTextField:UITextField!
	
	func configTextField(textField:UITextField) {
		titleTextField = textField
		titleTextField.placeholder = "Enter todo title"
	}
	
	@IBAction func addTodoBtn(_ sender: UIBarButtonItem) {
		let newTodoAlert = UIAlertController(title: "New todo", message: "Add new todo below", preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Add", style: .default, handler: self.saveNewTodo)
		let alertCancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		newTodoAlert.addAction(alertAction)
		newTodoAlert.addAction(alertCancelAct)
		newTodoAlert.addTextField(configurationHandler: configTextField)
		
		self.present(newTodoAlert, animated: true, completion: nil)
	}
	
	func saveNewTodo(alert:UIAlertAction) {
		//
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)!
		
		let todoTitle = NSManagedObject(entity: entity, insertInto: context)
		todoTitle.setValue(titleTextField.text, forKey: "title")
		
		do {
			try context.save()
			todoManager.todoItems.append(todoTitle)
		} catch {
			print("Error occured while saving new todo (error.localizedDescription)")
		}
		// arrange todos after save
		todoManager.fetchTodos()
		
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
	}
	
	
}
