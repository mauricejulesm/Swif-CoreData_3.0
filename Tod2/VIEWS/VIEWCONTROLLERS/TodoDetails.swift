//
//  TodoDetails.swift
//  Tod2
//
//  Created by Maurice on 9/30/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class TodoDetails: UIViewController {

    var todoTitle = "Your todo title: "
    var todoDeadline = ""
    
    
    override func loadView() {
        super.loadView()
        
        self.title = "Details"
        self.view.backgroundColor = .orange
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.text = todoTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0)
            ])
    }

}
