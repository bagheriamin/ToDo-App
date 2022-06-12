//
//  UIViewExtension Rouding.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
