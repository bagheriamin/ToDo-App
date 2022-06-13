//
//  AddEditViewController.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-12.
//

import UIKit

class AddEditViewController: UIViewController, UITextViewDelegate {

    let defaults = UserDefaults.standard
    
    @IBOutlet var saveButton: UIBarButtonItem!
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
        enableOrDisableSaveButton()
    }
    
    
    
    @IBAction func returnPressed(_ sender: UITextField) {
        taskNameTextField.resignFirstResponder()
        addedTask.title = taskNameTextField.text
        enableOrDisableSaveButton()

    }
    
    
    @IBAction func editingChangedTextField(_ sender: Any) {
        taskNameLabel.text = taskNameTextField.text
        addedTask.title = taskNameTextField.text
        enableOrDisableSaveButton()
    }
    
    func setUpViews() {
        if addedTask.title != nil, addedTask.deadline != nil {
            taskNameLabel.text = addedTask.title
            taskNameTextField.text = addedTask.title
            descriptionTextView.text = addedTask.description
            dueDatePicker.date = addedTask.deadline!
            isCompleted = addedTask.isCompleted!
            enableOrDisableSaveButton()
        }
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
        dueDatePicker.minimumDate = .now
        super.viewDidLoad()
        saveButton.isEnabled = false
        setUpViews()
        descriptionTextView.widthAnchor.constraint(equalToConstant: 388).isActive = true
        self.hideKeyboardWhenTappedAround()

        
        
        if defaults.bool(forKey: "buttonPressed") == true {
            clickMeImageView.isHidden = true
        }
        descriptionTextView.delegate = self
    
        // Do any additional setup after loading the view.
        //setting up complete color on launch
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
    
    
    
    func textViewDidChange(_ textView: UITextView) {
       
        addedTask.description = descriptionTextView.text
        print(addedTask)
        
    }
    
    func enableOrDisableSaveButton() {
        if addedTask.title != nil && addedTask.deadline != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
    }
    
    
    
    @IBAction func dateChanged(_ sender: Any) {
        print("DATE CHANGED")
        addedTask.deadline = dueDatePicker.date
        print(addedTask.deadline)
        enableOrDisableSaveButton()
    }
    
    

}
