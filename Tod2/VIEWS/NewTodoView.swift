//
//  NewTodoView.swift
//  Tod2
//
//  Created by Maurice on 9/23/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import UserNotifications

class NewTodoView: UIViewController {
    @IBOutlet weak var newTodoField: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    
    let datePicker = UIDatePicker()
    
    lazy var todoManager = TodoDataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnScreenTap()
         showDatePicker()
        
    }
    
    @IBAction func addTodoBtn(_ sender: Any) {
       // gotoColorViewController(newTodoField.text ?? "")
       
        let calendar = Calendar.current
        
        
        if let title = newTodoField.text, let deadline = dateLabel.text {
            if (title != "" && deadline != "") {
                
                
                //saving a new todo
                todoManager.saveNewTodo(title: title, deadline: deadline)

                // schedule the reminder
                registerNotifCategories()
                let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from:  getDateFromString(stringDate:deadline))
                scheduceNotification(todoContent:title, year:components.year!, month:components.month!,day:components.day!,hour:components.hour!,minute:components.minute!,second:components.second!)

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
        //center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "View your todo", options: .foreground)
        let remindMe = UNNotificationAction(identifier: "dismiss", title: "Dismiss", options: .foreground)
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

    
//    private func gotoColorViewController(_ title: String) {
//        let main = UIStoryboard.init(name: "Main", bundle: nil)
//        guard let nav = self.navigationController, let colorVc = main.instantiateViewController(withIdentifier: "ColorViewController") as? TodoDetailsViewController else {
//            return
//        }
//        colorVc.titleText =  title
//        nav.pushViewController(colorVc, animated: true)
//    }
}
