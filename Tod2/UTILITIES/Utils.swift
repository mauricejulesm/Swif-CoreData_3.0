//
//  File.swift
//  Tod2
//
//  Created by Maurice on 10/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//
import  UIKit

class Utilities  {
    
    let datePicker = UIDatePicker()

    func showDatePicker(from : UIView){
        
        let currentDate = Date()  //get the current date
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = currentDate
        datePicker.date = currentDate
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//
        //toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        //from.dateLabel.inputAccessoryView = toolbar
        //from.dateLabel.inputView = datePicker
        
    }
    
}
