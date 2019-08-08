//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Michael Moore on 8/7/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    var task: Task? {
        didSet{
            updateViews()
        }
    }
    
    var dueDateValue: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dueDateTextField.inputView = dueDatePicker
        title = task?.name
        updateViews()
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(userTappedView(_:)))
        self.tableView.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateValue = dueDatePicker.date
        dueDateTextField.text = dueDateValue?.stringValue()
    }

    @objc func userTappedView(_ sender: Any) {
            taskNameTextField.resignFirstResponder()
            dueDateTextField.resignFirstResponder()
            notesTextView.resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let task = task {
            updateTask(task: task)
        } else {
            guard let name = taskNameTextField.text,
                let notes = notesTextView.text else { return }
            
            TaskController.shared.add(taskWithName: name, notes: notes, isComplete: false, due: dueDatePicker.date)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func updateTask(task: Task) {
        guard let name = taskNameTextField.text,
        let notes = notesTextView.text else { return }
    
        let isComplete = task.isComplete
        
        if task == task {
            TaskController.shared.update(task: task, name: name, notes: notes, isComplete: isComplete, due: dueDatePicker.date)
        }
    }

    func updateViews() {
        loadViewIfNeeded()
        guard let task = task else { return }
        taskNameTextField.text = task.name
        notesTextView.text = task.notes
        dueDateTextField.text = task.due?.stringValue()
    }
}
