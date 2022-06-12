//
//  ViewController.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import UIKit

class PendingViewController: UIViewController {
    
    var pendingTasks: [Task] = [.init(title: "Make Millions", description: "Launch a business", deadline: Date(timeIntervalSinceNow: 86400), isCompleted: true), .init(title: "Lift Weights", description: "Push Day", deadline: Date(timeIntervalSinceNow: 86400), isCompleted: false), .init(title: "Order Pizza", description: "2 large Pepperoni's", deadline: Date(timeIntervalSinceNow: 86400), isCompleted: false)]
    //
    
    @IBOutlet var noTasksMessageView: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pendingTasks.isEmpty {
            print("Pending is empty")
            noTasksMessageView.isHidden = false
        } else {
            print("Pending is NOT empty")
            noTasksMessageView.isHidden = true
        }
    }
    
    // have to impliment the unwind segue in THE BOSS VC! Not in the second one.
    @IBAction func unwindToPendingTasks(sender: UIStoryboardSegue) {
        if sender.source is AddEditViewController {
            if let senderVC = sender.source as? AddEditViewController {
                pendingTasks.append(senderVC.addedTask)
                tableView.reloadData()
            }
            
        }
    }
    
}

extension PendingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingTaskCell", for: indexPath) as! CustomTableViewCell
        cell.taskTitleLabel.text = pendingTasks[indexPath.row].title
        cell.taskDescLabel.text = pendingTasks[indexPath.row].description
        let format = pendingTasks[indexPath.row].deadline?.getFormattedDate(format: "MMM d, h:mm a")
        
        if pendingTasks[indexPath.row].isCompleted == true {
            cell.completeTaskButton.alpha = 1
            cell.completedTaskImageBackground.isHidden = false
        } else if pendingTasks[indexPath.row].isCompleted == false {
            cell.completeTaskButton.alpha = 0
            cell.completedTaskImageBackground.isHidden = true
        }
        
        cell.dueDateLabel.text = format
        
        return cell
    }
    
    
}

