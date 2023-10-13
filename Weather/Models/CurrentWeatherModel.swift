//
//  CurrentWeatherModel.swift
//  Weather
//
//  Created by Khushbuben Patel on 09/10/23.
//

import Foundation

//MARK: - Current Weather
struct CurrentWeather: Codable {
  let coord: Coord
  let weather: [Weather]
  let base: String
  let main: Main
  let visibility: Int
  let wind: Wind
  let rain: Rain?
  let clouds: Clouds
  let dt: Int
  let sys: Sys
  let timezone, id: Int
  let name: String
  let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
  let all: Int
}

// MARK: - Coord
struct Coord: Codable {
  let lon: Double
  let lat: Double
}

// MARK: - Main
struct Main: Codable {
  let temp, feelsLike, tempMin, tempMax: Double
  let pressure, humidity : Int
  let seaLevel , grndLevel : Int?
  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case pressure, humidity
    case seaLevel = "sea_level"
    case grndLevel = "grnd_level"
  }
}

// MARK: - Rain
struct Rain: Codable {
  let the1H: Double
  enum CodingKeys: String, CodingKey {
    case the1H = "1h"
  }
}

// MARK: - Sys
struct Sys: Codable {
  let id: Int?
  let country: String?
  let sunrise, sunset: Int
  let type: Int?
}

// MARK: - Weather
struct Weather: Codable {
  let id: Int?
  let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
  let speed: Double
  let deg: Int
  let gust: Double?
}

// MARK: - City
struct City: Codable {
  let name: String
  let lat, lon: Double
  let country, state: String
  enum CodingKeys: String, CodingKey {
    case name
    case lat, lon, country, state
  }
}
