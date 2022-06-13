//
//  ViewController.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import UIKit

// here, we CONFORM TO THE PROTOCOL, and set this VC to be THE DELEGATE
class PendingViewController: UIViewController {
    
    
    
    var selectedTask = Task()
    var pendingTasks: [Task] = []
    //
    
    
    @IBOutlet var noTasksMessageView: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        print("The taks are: ", pendingTasks)
        theIndexPathThatWasPressed = nil
        print("view will appear")
        wasCellPressed = false
        if pendingTasks.isEmpty {
            print("Pending is empty")
            noTasksMessageView.isHidden = false
        } else {
            print("Pending is NOT empty")
            noTasksMessageView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view Did load")
        wasCellPressed = false
        if pendingTasks.isEmpty {
            print("Pending is empty")
            noTasksMessageView.isHidden = false
        } else {
            print("Pending is NOT empty")
            noTasksMessageView.isHidden = true
        }
    }
    
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        
    }
    // have to impliment the unwind segue in THE BOSS VC! Not in the second one.
    @IBAction func unwindToPendingTasks(sender: UIStoryboardSegue) {
        print("Going back to pending tasks")
        wasCellPressed = false
        if sender.source is AddEditViewController {
            
            if let senderVC = sender.source as? AddEditViewController {
                if senderVC.title == "Edit Task" {
                    pendingTasks.remove(at: theIndexPathThatWasPressed!)
                    pendingTasks.insert(senderVC.addedTask, at: theIndexPathThatWasPressed!)
                    tableView.reloadData()
                } else {
                    pendingTasks.append(senderVC.addedTask)
                    tableView.reloadData()
                }
                
            }
            
        }
    }
    var item = "Edit Task"
    var wasCellPressed: Bool = false {
        didSet {
            print("wasAddTaskPressed: ", wasCellPressed)
        }
    }
    var theIndexPathThatWasPressed: Int? = nil
}

extension PendingViewController: UITableViewDelegate, UITableViewDataSource, completeTaskDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingTaskCell", for: indexPath) as! CustomTableViewCell
        cell.taskTitleLabel.text = pendingTasks[indexPath.row].title
        
        let format = pendingTasks[indexPath.row].deadline?.getFormattedDate(format: "MMM d, h:mm a")
        
        if pendingTasks[indexPath.row].isCompleted == true {
            cell.completeTaskButton.alpha = 1
            cell.completedTaskImageBackground.isHidden = false
        } else if pendingTasks[indexPath.row].isCompleted == false {
            cell.completeTaskButton.alpha = 0
            cell.completedTaskImageBackground.isHidden = true
        }
        // here, we can now set this vc to be the delegate of the boss
        cell.delegate = self
        cell.indexPath = indexPath // setting the index path to where it get's created, and it gets set in the CELL! now we have access to it all over the project
        // conform to the protocol
        
        
        cell.dueDateLabel.text = format
        
        return cell
    }
    
    // gets access to the indexPath of the cell, BECAUSE WE SET IT IN THE CELL.INDEXPATH at (cellForRowAt)
    func biggerCompleteTaskButtonPressed(at index: IndexPath) {
        
         // index is equal to the indexPath in CustomTableViewCell.
            pendingTasks[index.row].isCompleted?.toggle()
            self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if (segue.identifier == "addEditTaskSegue") {
            if wasCellPressed == true {
               
                let vc = segue.destination as? AddEditViewController
                vc?.title = "Edit Task"
                vc?.addedTask = selectedTask
            } else {
                let vc = segue.destination as? AddEditViewController
                vc?.title = "Add Task"
                vc?.addedTask = Task()
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        theIndexPathThatWasPressed = indexPath.row
        wasCellPressed = true
        selectedTask = pendingTasks[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "addEditTaskSegue", sender: self)
    }
    
}

