//
//  CustomView.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation
import UIKit

//MARK: - UIColor
extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

//MARK: - UIFont
extension UIFont {
    static func robotoSlabMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoSlab-Medium", size: size)
    }
    
    static func robotoSlabLight(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoSlab-Light", size: size)
    }
}

//MARK: - labelUI
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

//MARK: - DateFormat
func todaysDate() -> String {
    
    let dateformater = DateFormatter()
    dateformater.dateStyle = .medium
    dateformater.locale = Locale.autoupdatingCurrent
    
    return dateformater.string(from: Date.now)
}

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

//MARK: - Image Format
func getImage(icon: String) -> String {
    
    switch icon {
    case "01d":
        return "ClearSkyIcon"
    case "02d":
        return "Cloudy"
    case "03d":
        return "Sun cloud mid rain"
    case "04d":
        return "Sun cloud angled rain"
    case "09d":
        return "Moon cloud mid rain"
    case "10d":
        return "Rain"
    case "11d":
        return "Tornado"
    case "13d":
        return "Mid snow fast winds"
    case "50d":
        return "Drizze"
    default:
        return "Moon cloud fast wind"
    }
}

//    case clearsky = "01d"
//    case fewclouds = "02d"
//    case scatteredclouds = "03d"
//    case brokenclouds = "04d"
//    case showerrain = "09d"
//    case rain = "10d"
//    case thunderstorm = "11d"
//    case snow = "13d"
//    case mist = "50d"

