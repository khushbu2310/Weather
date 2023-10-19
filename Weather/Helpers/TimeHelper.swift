//
//  TimeHelper.swift
//  Weather
//
//  Created by Khushbuben Patel on 18/10/23.
//

import Foundation
import UIKit

//MARK: - Time Format
func getTime(date: String) -> String {
    
    let dateformater1 = DateFormatter()
    dateformater1.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let originalDate = dateformater1.date(from: date)!
    
    let dateformater2 = DateFormatter()
    dateformater2.timeStyle = .short
    dateformater2.locale = Locale.autoupdatingCurrent
    
    return dateformater2.string(from: originalDate)
}
