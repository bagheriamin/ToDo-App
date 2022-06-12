//
//  CustomTableViewCell.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var uncompletedTaskImage: UIImageView!
    @IBOutlet var completedTaskImageBackground: UIImageView!
    @IBOutlet var completeTaskButton: UIButton!
    @IBOutlet var taskTitleLabel: UILabel!
    @IBOutlet var taskDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
