//
//  TaskController.swift
//  Task
//
//  Created by Michael Moore on 8/7/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    // Singleton
    static let shared = TaskController()
    
    //SoT
    let fetchedResultsController: NSFetchedResultsController<Task>
    
    init() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true), NSSortDescriptor(key: "due", ascending: false)]
        
        let resultsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch! \(error): \(error.localizedDescription)")
        }
    }
    
    //CRUD
    func add(taskWithName name: String, notes: String, isComplete: Bool, due: Date){
        let _ = Task(name: name, notes: notes, isComplete: isComplete, due: due)
        
        saveToPersistentStore()
    }
    
    func update(task: Task, name: String, notes: String, isComplete: Bool, due: Date) {
        task.name = name
        task.notes = notes
        task.due = due
        task.isComplete = isComplete
        
        saveToPersistentStore()
    }
    
    func remove(task: Task) {
        CoreDataStack.context.delete(task)
        
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was an error saving the objects in \(#function): \(error.localizedDescription)")
        }
    }
    
    func toggleIsComplete(for task: Task) {
        task.isComplete.toggle()
        saveToPersistentStore()
    }
}
