//
//  ViewController.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import UIKit

class PendingViewController: UIViewController {

    let pendingTasks: [Task] = [.init(title: "Make Millions", description: "Launch a business", deadline: Date(timeIntervalSinceNow: 86400)), .init(title: "Lift Weights", description: "Push Day", deadline: Date(timeIntervalSinceNow: 86400)), .init(title: "Order Pizza", description: "2 large Pepperoni's", deadline: Date(timeIntervalSinceNow: 86400))]
//
//    @IBOutlet var openingMessage: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: - ADD THE OPENING MESSAGE
        // Do any additional setup after loading the view.
//        if pendingTasks.isEmpty {
//            print("Pending is empty")
//            view.isHidden = false
//        } else {
//            print("Pending is NOT empty")
//            view.isHidden = true
//        }
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
        cell.dueDateLabel.text = format
        
        return cell
    }
    
    
}

