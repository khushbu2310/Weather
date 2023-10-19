//
//  MockWeatherAPI.swift
//  WeatherTests
//
//  Created by Khushbuben Patel on 19/10/23.
//

import Foundation
@testable import Weather

class MockWeatherAPI: Repository {
    
    var cityLocationResult: Result<Weather.LocationModel, Weather.WeatherRepoError>?
    var getCurrentWeatherResult: Result<Weather.CurrentWeatherDTO, Weather.WeatherRepoError>?
    var getForecastResult: Result<[Int : [Weather.ForecastDTO]], Weather.WeatherRepoError>?
    
    func getCityLocation(city: String, _ completation: @escaping (Result<Weather.LocationModel, Weather.WeatherRepoError>) -> Void) {
        completation(cityLocationResult!)
    }
    
    func getCurrentWeather(location: Weather.LocationModel, _ completation: @escaping (Result<Weather.CurrentWeatherDTO, Weather.WeatherRepoError>) -> Void) {
        completation(getCurrentWeatherResult!)
    }
    
    func getForecast(location: Weather.LocationModel, _ completation: @escaping (Result<[Int : [Weather.ForecastDTO]], Weather.WeatherRepoError>) -> Void) {
        completation(getForecastResult!)
    }
    
    func weather() -> CurrentWeatherDTO? {
        do {
            guard let weatherData = weatherData else {
                return nil
            }
            let weatherResult =  try JSONDecoder().decode(CurrentWeather.self, from: weatherData)
            let currentWeatherDTO = CurrentWeatherDTO(
                weatherType: weatherResult.weather.first?.main ?? "ClearSky",
                city: weatherResult.name,
                temp: String(weatherResult.main.temp),
                humidity: String(weatherResult.main.humidity),
                wind: String(weatherResult.wind.speed),
                icon: weatherResult.weather.first?.icon ?? "01d",
                lat: String(weatherResult.coord.lat),
                lon: String(weatherResult.coord.lon))
            return currentWeatherDTO
            
        } catch {
            return nil
        }
    }
    
    func forecast() -> [Int: [ForecastDTO]]? {
        do {
            guard let forecastData = forecastData else {
                return nil
            }
            let apiResponse =  try JSONDecoder().decode(FiveDaysForecastModel.self, from: forecastData)
            var response: [Int: [ForecastDTO]] = [:]
            
            apiResponse.list.forEach { data in
                
                let index = getKey(day: data.dtTxt)
                let tempDTO = (ForecastDTO(weatherType: data.weather.first?.main ?? "ClearSky", date: data.dtTxt, temp: data.main.temp ,icon:data.weather.first?.icon ?? "01") )
                if (response.keys.contains(index) == true) {
                    response[index]?.append(tempDTO)
                }
                else{
                    response.updateValue([tempDTO], forKey: index)
                }
            }
            return response
            
        }catch {
            return nil
        }
    }
    
    private func getKey(day: String) -> Int {
        
        var calender = Calendar.current
        let timzone = TimeZone.current
        calender.timeZone = timzone
        
        let StringToDate = DateFormatter()
        StringToDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        StringToDate.timeZone = timzone
        
        let fromDateString = StringToDate.string(from: Date())
        let fromDate = StringToDate.date(from: fromDateString)!
        let toDate = StringToDate.date(from: day)!
        
        
        let DateToString = DateFormatter()
        DateToString.dateFormat = "dd-MM-yyyy"
        DateToString.timeZone = timzone
        
        let d1 = DateToString.string(from: fromDate)
        let d2 = DateToString.string(from: toDate)
        let v1 = DateToString.date(from: d1)!
        let v2 = DateToString.date(from: d2)!
        
        let days = calender.dateComponents([.day], from: v1,to: v2).day!
        
        return days
    }
    
}


