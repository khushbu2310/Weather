//
//  LabelExtension.swift
//  Weather
//
//  Created by Khushbuben Patel on 18/10/23.
//

import Foundation
import UIKit

func labelUI(text: String?, textColor: UIColor?) -> UILabel {
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    if let textTitle = text {
        label.text = textTitle
    }
    if let textColor = textColor {
        label.textColor = textColor
    }
    
    return label
}
