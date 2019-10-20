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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Details"
		self.view.backgroundColor = .orange
		
	}
	

}
