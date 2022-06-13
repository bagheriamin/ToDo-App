//
//  task.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import Foundation

struct Task: Equatable {
    var title, description: String?
    var deadline: Date?
    var isCompleted: Bool?
}
