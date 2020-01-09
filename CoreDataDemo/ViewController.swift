//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Pavel Aushev on 24.12.2019.
//  Copyright © 2019 Павел Аушев. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    private let cellID = "cell"
    private var tasks: [Task] = []
    private let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "Tasks list"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewTask))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    @objc private func addNewTask() {
        showAlert(title: "New Task", message: "What do you want to do?")
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            guard let task = alertController.textFields?.first?.text, !task.isEmpty else {
                print("The text field is empty")
                return
            }
            
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addTextField()
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func save(_ taskName: String) {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        
        let task = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! Task
        
        task.name = taskName
        
        do {
            try managedContext.save()
            tasks.append(task)
            self.tableView.insertRows(at: [IndexPath(row: self.tasks.count-1, section: 0)], with: .automatic)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func fetchData() {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
        
        

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

