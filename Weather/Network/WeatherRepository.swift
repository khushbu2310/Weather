//
//  WeatherRepository.swift
//  Weather
//
//  Created by Khushbuben Patel on 16/10/23.
//

import Foundation

enum WeatherRepoError: String , Error {
    case cityNotFound = "City not found"
    case serverError = "Server Error"
}

protocol Repository {
    func getCityLocation(city: String,_ completation: @escaping (Result<LocationModel,WeatherRepoError>)->Void)
    func getCurrentWeather(location: LocationModel,_ completation: @escaping (Result<CurrentWeatherDTO,WeatherRepoError>)->Void)
    func getForecast(location: LocationModel,_ completation: @escaping (Result<[Int:[ForecastDTO]],WeatherRepoError>)->Void)
}

class WeatherRepository: Repository {
    func getCityLocation(city: String,_ completation: @escaping (Result<LocationModel,WeatherRepoError>) ->Void)  {
        
        APIManager.shared.request(apiRouter: WeatherAPIRouter.getCityLocation(city: city), modelType: [City].self) { result in
            switch result {
            case .success(let cityData):
                if let cityData = cityData.first  {
                    let location = LocationModel(lat: String(cityData.lat), lon: String(cityData.lon))
                    completation(.success(location))
                }
                else {
                    completation(.failure(.cityNotFound))
                }
             case .failure(let error):
                debugPrint("GetCityLocation Repo Error : \(error.localizedDescription)")
                completation(.failure(.serverError))
             }
        }
    }
                             
    func getCurrentWeather(location: LocationModel,
                           _ completation: @escaping ((Result<CurrentWeatherDTO,WeatherRepoError>)->Void)) {
         APIManager.shared.request(apiRouter: WeatherAPIRouter.getCurrentWeather(lat: location.lat, lon: location.lon),
                                   modelType: CurrentWeather.self) { result in
            switch result {
                    
                case.success(let weatherResult):
                    let currentWeatherDTO = CurrentWeatherDTO(weatherType: weatherResult.weather.first?.main ?? "Zaps",
                                                              city: weatherResult.name,
                                                              temp: String(weatherResult.main.temp),
                                                              humidity: String(weatherResult.main.humidity),
                                                              wind: String(weatherResult.wind.speed),
                                                              icon: weatherResult.weather.first?.icon ?? "01d",
                                                              lat: String(weatherResult.coord.lat),
                                                              lon: String(weatherResult.coord.lon))
                    
                    completation(.success(currentWeatherDTO))
                    
                case .failure(let error):
                    debugPrint("GetCurrentWeather Repo Error : \(error.localizedDescription)")
                    completation(.failure(.serverError))
                }
            }
    }
                             
     func getForecast(location: LocationModel, _ completation: @escaping ((Result<[Int:[ForecastDTO]],WeatherRepoError>)->Void))  {
                    
                    var response : [Int: [ForecastDTO]] = [:]
                    
                    APIManager.shared.request(apiRouter: WeatherAPIRouter.getFiveDaysForecast(lat: location.lat, lon: location.lon), modelType: FiveDaysForecastModel.self) {  forecastResult in
                        
                        switch forecastResult {
                        case .success(let result):  result.list.forEach { data in
                            
                            let index = self.getKey(day: data.dtTxt)
                            let tempDTO = (ForecastDTO(weatherType: data.weather.first?.main ?? "ClearSky", date: data.dtTxt, temp: data.main.temp ,icon:data.weather.first?.icon ?? "01") )
                            if (response.keys.contains(index) == true) {
                                response[index]?.append(tempDTO)
                            }
                            else{
                                response.updateValue([tempDTO], forKey: index)
                            }
                        }
                            completation(.success(response))
                        case .failure(let error):
                            debugPrint("GetForecastRepo Error : \(error.localizedDescription)")
                            completation(.failure(.serverError))
                        }
                    }
                }
    //    MARK: - GetDateFromString
                             
     private func getKey(day: String) -> Int {
                    
        var calender = Calendar.current
        let timezone = TimeZone.current
        calender.timeZone = timezone
        
        let StringToDate = DateFormatter()
        StringToDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        StringToDate.timeZone = timezone
        
        let fromDateString = StringToDate.string(from: Date())
        let fromDate = StringToDate.date(from: fromDateString)!
        let toDate = StringToDate.date(from: day)!
        
        let DateToString = DateFormatter()
        DateToString.dateFormat = "dd-MM-yyyy"
        DateToString.timeZone = timezone
        
        let d1 = DateToString.string(from: fromDate)
        let d2 = DateToString.string(from: toDate)
        let v1 = DateToString.date(from: d1)!
        let v2 = DateToString.date(from: d2)!
        
        let days = calender.dateComponents([.day], from: v1,to: v2).day!
        
        return days
    }
}
