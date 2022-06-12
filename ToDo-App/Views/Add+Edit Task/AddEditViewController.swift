//
//  AddEditViewController.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-12.
//

import UIKit

class AddEditViewController: UIViewController, UITextViewDelegate {

    let defaults = UserDefaults.standard
    
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var clickMeImageView: UIImageView!
    @IBOutlet var isCompletedButton: UIButton!
    
    
    var isCompleted: Bool = false
    var addedTask = Task()
    
    func setTask() {
        
        addedTask.title = taskNameTextField.text
        addedTask.description = descriptionTextView.text
        addedTask.isCompleted = isCompleted
        addedTask.deadline = dueDatePicker.date
    }
    
    
    
    @IBAction func returnPressed(_ sender: UITextField) {
        taskNameTextField.resignFirstResponder()
        addedTask.title = taskNameTextField.text

    }
    
    
    @IBAction func editingChangedTextField(_ sender: Any) {
        taskNameLabel.text = taskNameTextField.text
        addedTask.title = taskNameTextField.text
    }
    
    
    
    
    @IBAction func isCompletedButtonPressed(_ sender: UIButton) {
        defaults.set(true, forKey: "buttonPressed")
        if defaults.bool(forKey: "buttonPressed") == true {
            clickMeImageView.isHidden = true
        }
        isCompleted.toggle()
        if isCompleted {
            isCompletedButton.setTitleColor(.green, for: .normal)
            addedTask.isCompleted = isCompleted
            print(addedTask.isCompleted)

        } else {
            isCompletedButton.setTitleColor(.red, for: .normal)
            addedTask.isCompleted = isCompleted
            print(addedTask.isCompleted)
        }
    }
    
    override func viewDidLoad() {
        descriptionTextView.widthAnchor.constraint(equalToConstant: 388).isActive = true
        self.hideKeyboardWhenTappedAround()

        
        super.viewDidLoad()
        if defaults.bool(forKey: "buttonPressed") == true {
            clickMeImageView.isHidden = true
        }
        descriptionTextView.delegate = self
    
        // Do any additional setup after loading the view.
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
       
        addedTask.description = descriptionTextView.text
        print(addedTask)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if self.title == "Add Task" {
            print("Added Task!")
            
        }
    }
    
    
    
    @IBAction func dateChanged(_ sender: Any) {
        print("DATE CHANGED")
        addedTask.deadline = dueDatePicker.date
        print(addedTask.deadline)
    }
    
    

}
