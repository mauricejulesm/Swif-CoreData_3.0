//
//  ProjectsTableViewController.swift
//  Tod2
//
//  Created by Maurice on 10/4/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {

    var projects : [Project] = []
    
    // todo manager instance
    lazy var todosManager = DataManager()
    
    // monitor edit mode
    var editMode = false
    
    // right bar buttons
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// register custom project header
        let cellNib = UINib(nibName: "ProjectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ProjectCell")
		
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnTapped))
        self.navigationItem.rightBarButtonItem  = editBtn
        
        self.hideKeyboardOnScreenTap()
    }


    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = todosManager.getProjectFetchRequest()
        
        // sorting by the date created
        let sortDesc = NSSortDescriptor(key: "dateProjCreated", ascending: false)
        fetchRequest.sortDescriptors = [sortDesc]
        
        // fetching
        do {
            projects = try context.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch  {
            print("Unable to fetch categories")
        }
    }
    
    private lazy var addNewProjectButton: UIButton = {
        let addNewPersonButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 50)))
        addNewPersonButton.setTitle("Add New Project", for: .normal)
        addNewPersonButton.setTitleColor(.blue, for: .normal)
        addNewPersonButton.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 1.0, alpha: 1.0)
        addNewPersonButton.addTarget(self, action: #selector(addNewProjTapped), for: .touchUpInside)
        return addNewPersonButton
    }()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (!editMode) {
           guard let destinationVC = segue.destination as? TasksViewController,
            let selectedRow = self.tableView.indexPathForSelectedRow?.row else{ return }
            destinationVC.currentProject = projects[selectedRow]
        }else{
            guard let destinationVC = segue.destination as? NewProjectViewController,
            let selectedRow = self.tableView.indexPathForSelectedRow?.row else{ return }
            
            destinationVC.editMode = true
            destinationVC.currentProject = projects[selectedRow]
        }
       
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    /*
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Add new project"
        }

        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return CGFloat(100)
        }

        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
     
            let headerCell = Bundle.main.loadNibNamed("ProjectsHeader", owner: self, options: nil)?.first as! ProjectsHeader
            return headerCell
        }
 
 */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        let project = projects[indexPath.row]
        
        cell.projectInitialLbl.text = String(Array(project.name!)[0])
        cell.titleLabel.text = project.name
        cell.dateCreatedLbl.text = project.dateProjCreated
        
        if (editMode == true) {
            cell.backgroundColor = .lightGray
        }else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!editMode) {
            performSegue(withIdentifier: "showTodos", sender: self)
        }else{
            performSegue(withIdentifier: "addNewProj", sender: self)

        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteProject(at: indexPath)
        }    
    }
	
	// display the tableview cells with animations
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		
        if (!editMode) {
       
		// animation 1 [ not user friendly! ]
		let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
		cell.layer.transform = rotationTransform
		//cell.alpha = 0.5

		
		UIView.animate(withDuration: 1.0) {
			cell.layer.transform = CATransform3DIdentity
			//cell.alpha = 1.0
		}

		/*
		// animation 2 [ more user friendly & simpler! ]
		let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
		cell.layer.transform = rotationTransform
		cell.alpha = 0
		
		UIView.animate(withDuration: 0.75) {
			cell.layer.transform = CATransform3DIdentity
			cell.alpha = 1.0
		}
		*/
            
        }
		
	}
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return addNewProjectButton
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
   @objc func editBtnTapped() {
        editMode = true
        
        // add a done btn
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem  = doneBtn
        
        tableView.reloadData()
        print("Edit mode : \(editMode)")
    }
    
    @objc func doneEditing(){
        editMode = false
        
        // add a done btn
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnTapped))
        self.navigationItem.rightBarButtonItem  = editBtn
        
        tableView.reloadData()
        print("Edit mode : \(editMode)")
    }
    
    @objc func addNewProjTapped() {
        performSegue(withIdentifier: "addNewProj", sender: self)
        print("add new proj tapped")
    }
    
    func deleteProject(at indexPath: IndexPath) {
        let project = projects[indexPath.row]
        
        guard let context = project.managedObjectContext else { return }
//        context.undo()
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
