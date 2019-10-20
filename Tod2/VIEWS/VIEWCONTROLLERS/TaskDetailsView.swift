//
//  TodoDetails.swift
//  Tod2
//
//  Created by Maurice on 9/30/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class TaskDetails: UIViewController {
	@IBOutlet weak var titleLabel : UILabel!
	@IBOutlet weak var dateCreated : UILabel!
	@IBOutlet weak var deadline : UILabel!
	@IBOutlet weak var subtasks : UILabel!

	var currentTodo : Todo?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Task Details"
		titleLabel.text = "Task title: " + currentTodo!.title!
		dateCreated.text = currentTodo?.dateCreated
		deadline.text = currentTodo?.deadline
		subtasks.text = "Number of Subtasks: \(currentTodo?.subTodos?.count ?? 0)"

		self.view.backgroundColor = .orange
		
	}
	

}
