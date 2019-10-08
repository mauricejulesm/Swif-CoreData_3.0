//
//  NewTodoView.swift
//  Tod2
//
//  Created by Maurice on 9/23/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class NewTodoView: UIViewController {
    @IBOutlet weak var newTodoTitleField: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    
    let datePicker = UIDatePicker()
    
    lazy var todosManager = DataManager()
    lazy var notifManager = NotificationManager()
    lazy var alertManager = AlertsManager()
    var project: Project?

    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "New Task"
		
        self.hideKeyboardOnScreenTap()
         showDatePicker()
        
    }
    
    @IBAction func addTodoBtn(_ sender: Any) {
       
        let calendar = Calendar.current
        let dateCrted = "Created: " + todosManager.getTimeNow()
        var due = "Due: "
        
        if let title = newTodoTitleField.text, let deadline = dateLabel.text {
            if (title != "" && deadline != "") {
                due += deadline

                if let todo = Todo(completed: false, dateCreated: dateCrted, deadline: due, title: title) {
                    project?.addToRawTodos(todo)
                    do {
                        try todo.managedObjectContext?.save()
                    }catch{
                        print("Unable to save new expense")
                    }
                }
                
                // schedule the reminder
                notifManager.registerNotifCategories()
                let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from:  getDateFromString(stringDate:deadline))
                notifManager.scheduceNotification(todoContent:title, year:components.year!, month:components.month!,day:components.day!,hour:components.hour!,minute:components.minute!,second:components.second!)

                // dismiss current view and go to the main view
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
                
            }else{
                alertManager.showErrorAlert(from: self)
            }
        }
    }
    
    func getDateFromString(stringDate:String) -> Date {

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //    let formattedDate = format.string(from: date)
        let realDate = format.date(from: stringDate)!
        return realDate
    }

    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateLabel.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
