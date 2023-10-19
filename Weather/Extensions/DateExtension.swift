//
//  DateExtension.swift
//  Weather
//
//  Created by Khushbuben Patel on 18/10/23.
//

import Foundation

extension Date {
    
    func toWeekDay() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEEE"
        return dateFormater.string(from: self)
    }
    
    func toMediumStyle() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM d, yyyy"
        return dateFormater.string(from: self)
    }
}
