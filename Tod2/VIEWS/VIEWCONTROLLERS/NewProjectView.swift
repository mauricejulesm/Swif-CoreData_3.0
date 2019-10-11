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
    
    var currentProject : Project?
    var editMode = false
    
    // todo manager instance
    lazy var dataManager = DataManager()
    
    lazy var todosManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
        if (editMode) {
            titleTextField.text = currentProject?.name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func saveProject(_ sender: Any) {
        let title = titleTextField.text
        
        if (editMode) {
            dataManager.updateProject(title: currentProject!.name!, newTitle: title!)
             self.navigationController?.popViewController(animated: true)
        }else {
            
            let dateCreated = "Created: " + todosManager.getTimeNow()
            
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
}

extension NewProjectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
