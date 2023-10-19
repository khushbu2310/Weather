//
//  ForecastWeatherVM.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

class ForecastWeatherVM {
    
    private var repository: Repository
    var forecastData: [Int: [ForecastDTO]]
    var eventHandler:  ((_ event: Event) -> Void)?
    
    init(_repository: Repository = WeatherRepository(), _forecastData: [Int: [ForecastDTO]] = [:]){
        repository = _repository
        forecastData = _forecastData
    }
    
    func getForeCast(location: LocationModel){
        self.eventHandler?(.loading)
        repository.getForecast(location: location) { result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data) :
                self.forecastData = data
                self.eventHandler?(.dataLoaded)
            case .failure(let error) :
                self.eventHandler?(.error(error.rawValue))
            }
        }
    }
    
    func getNextFourDaysForcast()->[Int: [ForecastDTO]]{
        let data  = forecastData.filter { obj in
            obj.key != 0
        }
        var newData = [Int: [ForecastDTO]]()
        data.forEach { (key,val) in
            newData[key-1] = val
        }
        return newData
    }
}

extension ForecastWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String)
    }
}
