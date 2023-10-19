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
    let lat: String
    let lon: String
    
    init(weatherType: String, city: String, temp: String, humidity: String, wind: String, icon: String, lat: String, lon: String) {
        self.weatherType = weatherType
        self.city = city
        self.date = todaysDate()
        self.temp = temp
        self.humidity = humidity
        self.wind = wind
        self.icon = icon
        self.lat = lat
        self.lon = lon
    }
}

