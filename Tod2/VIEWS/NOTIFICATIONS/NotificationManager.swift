//
//  NotificationManager.swift
//  Tod2
//
//  Created by Maurice on 10/8/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    // register notification categories
    func registerNotifCategories() {
        let center = UNUserNotificationCenter.current()
        //center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "View your todo", options: .foreground)
        let remindMe = UNNotificationAction(identifier: "dismiss", title: "Dismiss", options: .foreground)
        let category = UNNotificationCategory(identifier: "todoReminderCatgr", actions: [show, remindMe], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    
    // schedule the notification
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
    
}
