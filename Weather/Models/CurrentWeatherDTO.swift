//
//  CurrentWeatherDTO.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

struct CurrentWeatherDTO {
    let weatherType: String
    let city: String
    let date: String
    let temp: String
    let humidity: String
    let wind: String
    let icon: String
    
    init(weatherType: String, code: Int, city: String, temp: String, humidity: String, wind: String, icon: String) {
        self.weatherType = weatherType
        self.city = city
        self.date = todaysDate()
        self.temp = temp
        self.humidity = humidity
        self.wind = wind
        self.icon = icon
    }
    
    func getURL() -> String {
        return "https://openweathermap.org/img/wn/\(self.icon)@2x.png"
    }
}

