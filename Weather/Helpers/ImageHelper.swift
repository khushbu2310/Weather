//
//  ImageHelper.swift
//  Weather
//
//  Created by Khushbuben Patel on 18/10/23.
//

import Foundation
import UIKit

func getImage(icon: String) -> String {
    
    switch icon {
    case "01d":
        return "Zaps"
    case "02d":
        return "Cloudy"
    case "03d":
        return "SunCloudMidRain"
    case "04d":
        return "SunCloudAngledRain"
    case "09d":
        return "MoonCloudMidRain"
    case "10d":
        return "Rain"
    case "11d":
        return "Tornado"
    case "13d":
        return "MidSnowFastWinds"
    case "50d":
        return "Drizze"
    case "01n":
        return "MoonCloudFastWind"
    case "02n":
        return "MoonFastWind"
    case "03n":
        return "MidSnowFastWinds"
    case "04n":
        return "Lightning"
    default:
        return "ClearSky"
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


