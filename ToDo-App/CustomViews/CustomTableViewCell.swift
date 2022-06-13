//
//  CustomTableViewCell.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import UIKit

protocol completeTaskDelegate {
    func biggerCompleteTaskButtonPressed(at index: IndexPath)
}

class CustomTableViewCell: UITableViewCell {
    
    // the boss needs to have access to the delegate
    var delegate: completeTaskDelegate!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var uncompletedTaskImage: UIImageView!
    @IBOutlet var completedTaskImageBackground: UIImageView!
    @IBOutlet var completeTaskButton: UIButton!
    @IBOutlet var taskTitleLabel: UILabel!
    @IBOutlet var biggerCompleteTaskButton: UIButton!
    var indexPath: IndexPath! // index path for the specific cell row
    
    //in the boss, we do most of the work. This means we 1) CREATE THE PROTOCOL. Then, 2) we give access to the BOSS CLASS, an instance of the delegate, abd tgeb we 3) WE SET THE FUNCTION NEEDED
    
    // when the button is pressed, the boss sends data to whoever is listenig (whoever conformed to the protocol)
    @IBAction func bgrCompleteTskButtonPressed(_ sender: UIButton) {
        self.delegate?.biggerCompleteTaskButtonPressed(at: indexPath) // indexPath is available to all who acces this protocol
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
