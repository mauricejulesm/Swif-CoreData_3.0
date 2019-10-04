//
//  TodoCustomCell.swift
//  TodosApp
//
//  Created by Maurice on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//
import UIKit

class ProjectCell: UITableViewCell {
    @IBOutlet weak var projectInitialLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateCreatedLbl: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var uiSwitchLabel: UISwitch!
    
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		titleLabel.sizeToFit()
		titleLabel.layoutIfNeeded()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	@IBAction func todoStatusSwitcher(_ sender: Any) {
	}
}
