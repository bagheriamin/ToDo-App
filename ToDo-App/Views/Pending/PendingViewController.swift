//
//  ViewController.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import UIKit
import UserNotifications



// here, we CONFORM TO THE PROTOCOL, and set this VC to be THE DELEGATE
class PendingViewController: UIViewController {
    
    var indexPath: IndexPath?
    var timer: Timer?
    
    @objc func updateLabel() {
        
        if pendingTasks != [] {
            for task in pendingTasks {
                if task.deadline! < Date.now && task.isCompleted == false {
                    overdueTasks.append(task)
                        if let index = pendingTasks.firstIndex(of: task) {
                            pendingTasks.remove(at: index)
                            tableView.reloadData()
                        }
                    }
            }
        }
        var tabNumber = 0
        
        
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the second tab:
            if overdueTasks != [] {
                let tabItem = tabItems[1]
                tabItem.badgeValue = ""
            } else {
                let tabItem = tabItems[1]
                tabItem.badgeValue = nil
            }
            
        }
    }
    
    var selectedTask = Task()
    let itemsKey: String = "items_list"
    var pendingTasks: [Task] = [] {
        didSet {
            for task in pendingTasks {
                
                createAndTriggerNotification(time: 10, task: task)
            }
            saveItems()
            
        }
    }
    //
    func createAndTriggerNotification(time: Int, task: Task) {
        guard let deadline = task.deadline else { return }
        if task.deadline! > Date.now {
            print("Iterating through the array")
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = task.title!
            notificationContent.body = "10 Minutes to do: " + (task.desc ?? "task")!
            notificationContent.sound = .defaultRingtone
            
            
            guard let earlyDate = (task.deadline?.withAddedMinutes(minutes: Double(time))) else { return }
            
            let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute), from: earlyDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "tenMinutesBeforetaskEndsUN", content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error: ", error.localizedDescription)
                } else {
                    print("notification set up successfully for \(task)")
                }
            }
            
        }
        
        
        
    }
    
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
    
    func getOverdueItems() {
        guard
            let data = UserDefaults.standard.data(forKey: "savedOverdueTasks"), let savedItems = try? JSONDecoder().decode([Task].self, from: data)
        else { return }
        
        overdueTasks = savedItems
    }
    
    override func viewDidLoad() {
        getOverdueItems()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:  [.alert, .sound]) { (granted, error) in
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(updateLabel)), userInfo: nil, repeats: true)
        
        getItems()
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
        
        tableView.dragInteractionEnabled = true // Enable intra-app drags
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        
    }
    
    @IBOutlet var addTaskButton: UIBarButtonItem!
    @IBAction func addTaskButtonPressed(_ sender: Any) { }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if pendingTasks != [] {
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
                sender.title = "Edit"
                addTaskButton.isEnabled = true
            } else {
                tableView.setEditing(true, animated: true)
                sender.title = "Done"
                addTaskButton.isEnabled = false
            }
        }
        
        
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
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(pendingTasks) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
            print(encodedData)
        }
        
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey), let savedItems = try? JSONDecoder().decode([Task].self, from: data)
        else { return }
        
        self.pendingTasks = savedItems
    }
}

extension PendingViewController: UITableViewDelegate, UITableViewDataSource, completeTaskDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    
    
    // >>----->> HOW TO GET DRAG AND DROP <<-----<< || >-> Make sure to conform model class <-<
    // must include items for beginning
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = pendingTasks[indexPath.row]
        // create an item provideer of type NSItemProvider
        let itemProvider = NSItemProvider(object: task)
        // use that as my drag item
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        return [dragItem]
    }
    
    // must include dropSessionDidUpdate
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    
    // must include Perform Drop With
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let insertionIndex: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            insertionIndex = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            insertionIndex = IndexPath(row: row, section: section)
        }
        
        for item in coordinator.items {
            guard let sourceIndexPathRow = item.sourceIndexPath?.row else { continue }
            item.dragItem.itemProvider.loadObject(ofClass: Task.self) { (object, error) in
                DispatchQueue.main.async {
                    if let task = object as? Task {
                        self.pendingTasks.remove(at: sourceIndexPathRow)
                        self.pendingTasks.insert(task, at: insertionIndex.row)
                        tableView.reloadData()
                    } else {
                        return
                    }
                }
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingTaskCell", for: indexPath) as! CustomTableViewCell
        cell.taskTitleLabel.text = pendingTasks[indexPath.row].title
        
        if pendingTasks[indexPath.row].isCompleted ?? false {
            cell.completeTaskButton.isEnabled = true
            cell.completeTaskButton.isHidden = false
            cell.completedTaskImageBackground.isHidden = false
            cell.completeTaskButton.alpha = 1
        } else {
            cell.completeTaskButton.isEnabled = true
            cell.completeTaskButton.alpha = 0
            cell.completedTaskImageBackground.isHidden = true
            cell.uncompletedTaskImage.isHidden = false
        }
        
        let format = pendingTasks[indexPath.row].deadline?.getFormattedDate(format: "MMM d, h:mm a")
        
        
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
        saveItems()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pendingTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = pendingTasks[sourceIndexPath.row]
        pendingTasks.remove(at: sourceIndexPath.row)
        pendingTasks.insert(itemToMove, at: destinationIndexPath.row)
        
    }
    
}

