//
//  Project+CoreDataClass.swift
//  Tod2
//
//  Created by Maurice on 10/7/19.
//  Copyright © 2019 maurice. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Project)
public class Project: NSManagedObject {

    var todos: [Todo]? {
        return self.rawTodos?.array as? [Todo]
    }
    
    convenience init?(dateProjCreated:String, name: String){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Project.entity(), insertInto: context)
        self.dateProjCreated = dateProjCreated
        self.name = name
    }
    
}
