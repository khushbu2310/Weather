//
//  CurrentWeatherVM.swift
//  Weather
//
//  Created by Khushbuben Patel on 18/10/23.
//

import Foundation

class CurrentWeatherVM {
    
    var repository: Repository
    var currentWeatherDTO:  CurrentWeatherDTO?
    var eventHandler: ((_ event: Event) -> Void)?
    var currentLocation: LocationModel!
    var topCollectionViewData: [(String, String)] = [
        ("Clear Sky","ClearSky"),
        ("Few clouds","Cloudy"),
        ("Scattered clouds","SunCloudMidRain"),
        ("Broken clouds","SunCloudAngledRain"),
        ("Shower rain","MoonCloudMidRain"),
        ("Rain","Rain"),
        ("Moon wind","MoonCloudFastWind"),
        ("Thunderstorm","Tornado"),
        ("Snow","Drizze"),
        ("Snow wind","MidSnowFastWinds"),
        ("Heat","Zaps")
    ]

    init(_repository: Repository = WeatherRepository()){
        repository = _repository
    }
    
    func getCurrentWeather(location: LocationModel){
        self.eventHandler?(.loading)
        self.repository.getCurrentWeather(location: location) { result  in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data) :
                self.currentWeatherDTO = data
                self.eventHandler?(.dataLoaded)
            case .failure(let error) :
                self.eventHandler?(.error(error.rawValue))
            }
        }
    }
}

//  MARK: - EventHandler
extension CurrentWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String)
    }
}
