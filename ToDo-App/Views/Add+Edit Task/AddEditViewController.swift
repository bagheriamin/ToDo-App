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
    
    
    
    
    
    @IBAction func returnPressed(_ sender: UITextField) {
        taskNameTextField.resignFirstResponder()
        addedTask.title = taskNameTextField.text
        enableOrDisableSaveButton()

    }
    
    
    @IBAction func editingChangedTextField(_ sender: Any) {
        print("writing...")
        taskNameLabel.text = taskNameTextField.text
        addedTask.title = taskNameTextField.text
        print(addedTask.title)
        print(addedTask.deadline)
        enableOrDisableSaveButton()
    }
    
    func setUpViews() {
        if addedTask.title != nil, addedTask.deadline != nil {
            taskNameLabel.text = addedTask.title
            taskNameTextField.text = addedTask.title
            descriptionTextView.text = addedTask.desc
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
        enableOrDisableSaveButton()
        if addedTask.deadline == nil {
            dueDatePicker.minimumDate = .now
        }
        
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
       
        addedTask.desc = descriptionTextView.text
        print(addedTask)
        
    }
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    func enableOrDisableSaveButton() {
        if let deadline = addedTask.deadline {
            if deadline < Date.now {
                saveButton.isEnabled = false
                dueDatePicker.isEnabled = false
                taskNameTextField.isEnabled = false
                descriptionTextView.isEditable = false
                isCompletedButton.isEnabled = false
                isCompletedButton.alpha = 0.3
                dueDatePicker.alpha = 0.3
                descriptionTextView.alpha = 0.3
                taskNameTextField.alpha = 0.3
                taskNameLabel.alpha = 0.3
                descriptionLabel.alpha = 0.3
                dueDateLabel.alpha = 0.3
                isCompletedButton.tintColor = .gray
            }
        }
        
        if let deadline = addedTask.deadline {
            if deadline > Date.now {
                if addedTask.title != nil && addedTask.deadline != nil {
                    saveButton.isEnabled = true
                } else if addedTask.title == nil && addedTask.deadline == nil {
                    saveButton.isEnabled = false
                }
            }
            
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
    }
    
    
    
    @IBAction func dateChanged(_ sender: Any) {
        print("DATE CHANGED")
        addedTask.deadline = dueDatePicker.date
        print(addedTask.title)
        print(addedTask.deadline)
        enableOrDisableSaveButton()
    }
    
    

}
