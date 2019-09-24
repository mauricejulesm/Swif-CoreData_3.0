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
		self.hideKeyboardOnScreenTap()
        
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
        performSegue(withIdentifier: "NewTodo", sender: self)
	}
	
    @objc func registerLocal() {
        
    }
	
}
extension UIViewController {
    func hideKeyboardOnScreenTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
