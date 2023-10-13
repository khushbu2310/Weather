//
//  SearchWeatherVM.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

struct SearchResult {
    let name: String
    let weatherType: String
    let temp: String
}

class SearchWeatherVM {
    var eventHandler: ((_ event: Event) -> Void)?
    var searchErrorMessage: String = ""
    var searchResults: [CurrentWeatherDTO] = []
    
    func getWeather(name: String) {
        self.eventHandler?(.loading)
        
        var cityLocation: Location?
        APIManager.shared.request(apiRouter: WeatherAPIRouter.getCityLocation(city: name), modelType: [City].self) { response in
            
            switch response {
            case .success(let city): if let city = city.first {
                cityLocation = Location(lat: String(city.lat), lon: String(city.lon))
            } else {
                self.eventHandler?(.stopLoading)
                self.searchErrorMessage = "City not found"
                self.eventHandler?(.error)
                return
            }
            case .failure(let error): self.searchErrorMessage = error.localizedDescription
                self.eventHandler?(.error)
                return
            }
            
            if let getCityLocation = cityLocation {
                APIManager.shared.request(apiRouter: WeatherAPIRouter.getCurrentWeather(lat: getCityLocation.lat, lon: getCityLocation.lon), modelType: CurrentWeather.self) { response in
                    self.eventHandler?(.stopLoading)
                    switch response {
                    case .success(let result):
                        self.searchResults.insert(CurrentWeatherDTO(weatherType: result.weather.first?.main ?? "ClearSky", code: result.weather.first?.id ?? 0, city: result.name, temp: String(result.main.temp), humidity: String(result.main.humidity), wind: String(result.wind.speed), icon: result.weather.first?.icon ?? "1d") , at: 0)
                        print(result)
                        self.eventHandler?(.dataLoaded)
                        
                    case .failure(let error): self.searchErrorMessage = error.localizedDescription
                    }
                }
            }
            
        }
    }
    
    func resizeSearchResult() {
        if searchResults.count > 4 {
            searchResults.removeLast()
        }
    }
}

extension SearchWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error
    }
}
