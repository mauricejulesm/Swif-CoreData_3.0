//
//  NewProjectViewController.swift
//  Tod2
//
//  Created by Maurice on 10/7/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class NewProjectViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func saveProject(_ sender: Any) {
        let title = titleTextField.text
        let dateCreated = "Monday, Sept 03 2019"
        
        if title == "" {
            print("Category title can't be empty! Try again.")
            return
        }
        
        let newProject = Project(dateProjCreated: dateCreated, name: title!)
        
        do {
            try newProject?.managedObjectContext?.save()
            print("Saved category: \(title!) successfully")
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Unable to save the new category \(title!)")
        }
    }
}

extension NewProjectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
