//
//  TodoCustomCell.swift
//  TodosApp
//
//  Created by Maurice on 9/21/19.
//  Copyright © 2019 maurice. All rights reserved.
//
import UIKit

class TodoCell: UITableViewCell {
	@IBOutlet weak var todoImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateCreatedLbl: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var uiSwitchLabel: UISwitch!
	@IBOutlet weak var addSubTaskBtn: UIButton!
    
	var opened = false
	
    
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
	
//    func commonInit(_ imageName:String, id:Int64, title:String,dateCreated:String, deadline:String){
//        todoImage.image = UIImage(named: imageName)
//        titleLabel.text = title
//        dateCreatedLbl.text = dateCreated
//        deadLineLabel.text = deadline
//    }
    
    
   
    
	
}
