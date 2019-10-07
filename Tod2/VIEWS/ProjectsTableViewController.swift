//
//  ProjectsTableViewController.swift
//  Tod2
//
//  Created by Maurice on 10/4/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import CoreData

class ProjectsTableViewController: UITableViewController {

    var projects : [Project] = []
    
    // todo manager instance
    lazy var todosManager = TodoDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.barTintColor = .green
        let cellNib = UINib(nibName: "ProjectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ProjectCell")
        self.hideKeyboardOnScreenTap()
    }


    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Project> = Project.fetchRequest()
        
        // fetching
        do {
            projects = try context.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch  {
            print("Unable to fetch categories")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TodosViewController,
            let selectedRow = self.tableView.indexPathForSelectedRow?.row else{
                return
        }
        destinationVC.currentProject = projects[selectedRow]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        let project = projects[indexPath.row]
        
        cell.projectInitialLbl.text = String(Array(project.name!)[0])
        cell.titleLabel.text = project.name
        cell.dateCreatedLbl.text = todosManager.getTimeNow()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTodos", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteProject(at: indexPath)
        }    
    }
    
    
    func deleteProject(at indexPath: IndexPath) {
        let project = projects[indexPath.row]
        
        guard let context = project.managedObjectContext else { return }
        context.delete(project)
        do {
            try context.save()
            projects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch  {
            print("Unable to delete the category")
          self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
}
