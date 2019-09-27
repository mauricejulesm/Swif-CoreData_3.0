//
//  NewTodoView.swift
//  Tod2
//
//  Created by Maurice on 9/23/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class NewTodoView: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet weak var newTodoField: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    
    let datePicker = UIDatePicker()
    
    lazy var todoManager = TodoDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnScreenTap()
         showDatePicker()
        
    }
    
    @IBAction func saveNewTodo(_ sender: Any) {
        let calendar = Calendar.current
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let newTodoTitle = newTodoField.text, let deadline = dateLabel.text {
            if (newTodoTitle != "" && deadline != "") {
                let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)!
                let todo = NSManagedObject(entity: entity, insertInto: context)
                let date = "Created: " + todoManager.getTimeNow()
                let due = "Due: " + deadline
                let completed = false
                
                
                todo.setValue(newTodoTitle, forKey: "title")
                todo.setValue(date, forKey: "dateCreated")
                todo.setValue(due, forKey: "deadline")
                todo.setValue(completed, forKey: "completed")

                do {
                    try context.save()
                    todoManager.todoItems.append(todo)
                } catch {
                    print("Error occured while saving new todo (error.localizedDescription)")
                }
                
                // schedule the reminder
                registerNotifCategories()
                let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from:  getDateFromString(stringDate:deadline))
                scheduceNotification(todoContent:newTodoTitle, year:components.year!, month:components.month!,day:components.day!,hour:components.hour!,minute:components.minute!,second:components.second!)

                
                // dismiss current view and go to the main view
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }else{
                showErrorAlert()
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        if response.actionIdentifier == "show" {
            print("Showing the current todo reminder u tapped!")
        }
        
//        switch response.actionIdentifier {
//        case "show":
//            showToast(message: "Showing the current todo reminder u tapped!")
//            print("Showing the current todo reminder u tapped!")
//        case "remind-me-later":
//            showToast(message: "You chose to remind in 10 minutes")
//            print("You chose to remind in 10 minutes")
//        default:
//            print("Nothing chosen")
//        }
    }
    
    func scheduceNotification(todoContent:String, year:Int,month:Int,day:Int,hour:Int,minute:Int,second:Int) {

        let notifCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Your todo reminder"
        //content.subtitle = "This is your reminder subtitle"
        content.body = "\(todoContent)"
        content.categoryIdentifier = "todoReminderCatgr"
        content.badge = 1
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        //var dateNow = getDateObject(stringDate: "2019-09-24 10:15:19")
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notifCenter.add(request)
        
        print("Todo reminder notification scheduled!")
    }
    // register notification categories
    func registerNotifCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "View your todo", options: .foreground)
        let remindMe = UNNotificationAction(identifier: "remind-me-later", title: "Remind me in 10 minutes", options: .foreground)
        let category = UNNotificationCategory(identifier: "todoReminderCatgr", actions: [show, remindMe], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    // show an alert on error while creating a todo
    func showErrorAlert() {
        
                let errorAlert = UIAlertController(title: "Error", message: "Make sure title and deadline are not empty", preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "Add", style: .default, handler: self.saveNewTodo)
                let alertCancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
//                errorAlert.addAction(alertAction)
                errorAlert.addAction(alertCancelAct)
//                errorAlert.addTextField(configurationHandler: configTextField)
        
                self.present(errorAlert, animated: true, completion: nil)
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
