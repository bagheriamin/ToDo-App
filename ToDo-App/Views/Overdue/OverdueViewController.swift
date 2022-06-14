//
//  OverdueViewController.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import UIKit

var overdueTasks: [Task] = [] {
    didSet {
        if let encodedData = try? JSONEncoder().encode(overdueTasks) {
            UserDefaults.standard.set(encodedData, forKey: "savedOverdueTasks")
            print(encodedData)
        }
    }
}

class OverdueViewController: UIViewController{
    
    var timer: Timer?
    
    
    
//    @objc func updateBadge() {
////        var tabNumber = 0
////
////
////        if let tabItems = tabBarController?.tabBar.items {
////            // In this case we want to modify the badge number of the second tab:
////            if overdueTasks != [] {
////                let tabItem = tabItems[1]
////                tabItem.badgeValue = ""
////            } else {
////                let tabItem = tabItems[1]
////                tabItem.badgeValue = nil
////            }
////
////        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        getItems()
        
        tableView.reloadData()
        
        
        
        
    }
    
    
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateBadge)), userInfo: nil, repeats: true)
        getItems()
       
    }
 
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: "savedOverdueTasks"), let savedItems = try? JSONDecoder().decode([Task].self, from: data)
        else { return }
        
        overdueTasks = savedItems
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if overdueTasks != [] {
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
                sender.title = "Edit"
            } else {
                tableView.setEditing(true, animated: true)
                sender.title = "Done"
            }
        }
        
        
    }
    
    var theIndexPathThatWasPressed: Int? = nil
    var selectedTask = Task()
    
    
    @IBAction func deleteAllButtonPressed(_ sender: Any) {
        overdueTasks.removeAll()
        tableView.reloadData()
    }
    
}

extension OverdueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overdueTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingTaskCell", for: indexPath) as! CustomTableViewCell
        cell.taskTitleLabel.text = overdueTasks[indexPath.row].title
        
        let format = overdueTasks[indexPath.row].deadline?.getFormattedDate(format: "MMM d, h:mm a")
        
        
        
        cell.dueDateLabel.text = format
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            overdueTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = overdueTasks[sourceIndexPath.row]
        overdueTasks.remove(at: sourceIndexPath.row)
        overdueTasks.insert(itemToMove, at: destinationIndexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        theIndexPathThatWasPressed = indexPath.row
        selectedTask = overdueTasks[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "addEditTaskSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "addEditTaskSegue") {
            
            
            let vc = segue.destination as? AddEditViewController
            vc?.title = "Edit Task"
            vc?.addedTask = selectedTask
            vc?.saveButton.isEnabled = false
            
        }
    }
}
