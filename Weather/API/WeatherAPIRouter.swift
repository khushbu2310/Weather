//
//  WeatherAPIRouter.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

enum Constant {
    static let HOST = "api.openweathermap.org"
    static let WeatherSchema = "https"
    static let GeoSchema = "https"
    static let APIKey = "92d729cbfd5c2c278af3e7d6e23b3589"
    static let currentWeatherPath = "/data/2.5/weather"
    static let fiveDaysForecastPath = "/data/2.5/forecast"
    static let geoPath = "/geo/1.0/direct"
}

enum WeatherAPIRouter: APIRouter {
    
    case getCurrentWeather(lat: String, lon: String)
    case getCityLocation(city: String)
    case getFiveDaysForecast(lat: String, lon: String)
    
    var host: String {
        switch self {
        case .getCurrentWeather, .getCityLocation, .getFiveDaysForecast:
            return Constant.HOST
        }
    }
    
    var schema: String {
        switch self {
        case .getCurrentWeather, .getCityLocation, .getFiveDaysForecast:
            return "https"
        }
    }
    
    var path: String {
        switch self {
        case .getCurrentWeather:
            return Constant.currentWeatherPath
        case .getCityLocation:
            return Constant.geoPath
        case .getFiveDaysForecast:
            return Constant.fiveDaysForecastPath
        }
    }
    
    var method: String {
        switch self {
        case .getCurrentWeather, .getCityLocation, .getFiveDaysForecast:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getCurrentWeather(let lat, let lon):
            return [URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "lon", value: lon),
                    URLQueryItem(name: "appid", value: Constant.APIKey),
                    URLQueryItem(name: "units", value: "metric")]
        
        case .getCityLocation(let city):
            return[URLQueryItem(name: "q", value: city),
                   URLQueryItem(name: "limit", value: "1"),
                   URLQueryItem(name: "appid", value: Constant.APIKey)]

        case .getFiveDaysForecast(let lat, let lon):
            return [URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "lon", value: lon),
                    URLQueryItem(name: "appid", value: Constant.APIKey),
                    URLQueryItem(name: "units", value: "metric")]

        }
    }
    
    var headers: [(String, String)] {
        switch self {
        case .getCurrentWeather, .getCityLocation, .getFiveDaysForecast:
            return [("Content-Type", "application-json")]
        }
    }
    
    var statusCode: Int {
        switch self {
        case .getCurrentWeather, .getCityLocation, .getFiveDaysForecast:
            return 200
        }

    }
    
    var body: Codable? {
        switch self {
        case .getCurrentWeather, .getCityLocation, .getFiveDaysForecast:
            return nil
        }

    }
    
    
}
