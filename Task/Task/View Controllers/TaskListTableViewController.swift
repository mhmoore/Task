//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Michael Moore on 8/7/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, ButtonTableViewCellDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskController.shared.fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.shared.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionHeader = TaskController.shared.fetchedResultsController.sections?[section] else { return ""}
        return sectionHeader.name == "0" ? "Incomplete" : "Complete"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
        

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskNameCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell()}
        
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.update(withTask: task)
        cell.delegate = self
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
            TaskController.shared.remove(task: task)
            
        }
    }
    
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
            let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        TaskController.shared.toggleIsComplete(for: task)
        sender.updateButton(task.isComplete)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "toTaskDetailTVC" {
            guard let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TaskDetailTableViewController,
                let task = TaskController.shared.fetchedResultsController.fetchedObjects?[index.row] else { return }
            
            destinationVC.task = task
            destinationVC.dueDateValue = task.due
        }
    }
}

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
