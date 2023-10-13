//
//  CurrentWeatherVM.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation
import CoreLocation

struct Location {
    let lat: String
    let lon: String
}

class CurrentWeatherVM {
    var currentWeatherDTO: CurrentWeatherDTO?
    var eventHandler: ((_ event: Event) -> Void)?
    var locationManager = CLLocationManager()
    var currentLocation: Location!
    var foreCastDTOs: [ForecastDTO] = []
    var weatherErrorMessage: String = ""
    var forecastErrorMessage: String = ""
    var topCollectionViewData: [(String, String)] = [("Rain","Rain"),
                                                     ("Cloud Rain","Sun cloud mid rain"),
                                                     ("Mid Rain","Moon cloud mid rain"),
                                                     ("Light rain","Sun cloud angled rain"),
                                                     ("Drizze","Drizze"),
                                                     ("Thunder","Zaps"),
                                                     ("Tornado","Tornado"),
                                                     ("Cloudy","Cloudy"),
                                                     ("Lightning","Lightning"),
                                                     ("Moon Wind","MoonFastWind"),
                                                     ("Moon Cloud","Moon cloud fast wind"),
                                                     ("Fast wind","Mid snow fast winds")]
    init() {
        getUserLocation()
    }
    
    func getUserLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        
        self.currentLocation = Location(lat: String(self.locationManager.location?.coordinate.latitude ?? 0.0), lon: String(self.locationManager.location?.coordinate.longitude ?? 0.0))
    }
    
    func getCurrentWeather(location: Location) {
        self.eventHandler?(.loading)
        
        APIManager.shared.request(apiRouter: WeatherAPIRouter.getCurrentWeather(lat: location.lat, lon: location.lon), modelType: CurrentWeather.self) { [weak self] response in
            self?.eventHandler?(.stopLoading)
            
            switch response {
            case .success(let result): self?.currentWeatherDTO = CurrentWeatherDTO(weatherType: result.weather.first?.main ?? "ClearSky", code: result.weather.first?.id ?? 0, city: result.name, temp: String(result.main.temp), humidity: String(result.main.humidity), wind: String(result.wind.speed), icon: result.weather.first?.icon ?? "01")
                
                self?.eventHandler?(.dataLoaded)
                
            case .failure(let error): self?.weatherErrorMessage = error.localizedDescription
                self?.eventHandler?(.error(error))
            }
            
        }
        
    }
    
}

extension CurrentWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
