//
//  NewTodoView.swift
//  Tod2
//
//  Created by Maurice on 9/23/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import CoreData

class NewTodoView: UIViewController {
    @IBOutlet weak var newTodoField: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    
    let datePicker = UIDatePicker()
    
    lazy var todoManager = TodoDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()

         showDatePicker()
    }
    

    @IBAction func submitTodo(_ sender: Any) {
//        if let newTodoTitle = newTodoField.text{
//            if !newTodoTitle.isEmpty && !dateLabel.text!.isEmpty{
//                let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
//
//                if let todoEntity = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context) as? Todo {
//                    todoEntity.id = 0
//                    todoEntity.title = newTodoTitle
//                    todoEntity.completed = false
//                    todoEntity.deadline = "Deadline: " + dateLabel.text!
//
//                    print("created new todo\(newTodoTitle)")
//
//                    do{
//                        try context.save()
//                    }catch{
//                        print("There was an error while saving the new todo")
//                    }
//
//                    print("Added new todo: \(newTodoTitle)")
//                    newTodoField.text = ""
//                    dateLabel.text = ""
//                }
//            }
//        }
    }
    
    @IBAction func saveNewTodo(_ sender: Any) {
        //
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
       
        
        if let newTodoTitle = newTodoField.text {
            if (newTodoTitle != "") {
                let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)!
                let todoTitle = NSManagedObject(entity: entity, insertInto: context)
                
                todoTitle.setValue(newTodoTitle, forKey: "title")
                do {
                    try context.save()
                    todoManager.todoItems.append(todoTitle)
                } catch {
                    print("Error occured while saving new todo (error.localizedDescription)")
                }
                
                // dismiss current view and go to the main view
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }else{
                showErrorAlert()
            }
        }
    }
    
    
    func showErrorAlert() {
        
                let errorAlert = UIAlertController(title: "Error", message: "Todo title can't be empty", preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "Add", style: .default, handler: self.saveNewTodo)
                let alertCancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
//                errorAlert.addAction(alertAction)
                errorAlert.addAction(alertCancelAct)
//                errorAlert.addTextField(configurationHandler: configTextField)
        
                self.present(errorAlert, animated: true, completion: nil)
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateLabel.inputAccessoryView = toolbar
        dateLabel.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

}
