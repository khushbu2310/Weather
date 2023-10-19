//
//  ForecastWeatherVM.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

class ForecastWeatherVM {
    
    var foreCastDTOs: [ForecastDTO] = []
    var todayForecast: [ForecastDTO] = []
    var nextFourDaysForecast: [Int: [ForecastDTO]] = [:]
    var forecastResultData: [Int: [ForecastDTO]] = [:]
    var forecastErrorMessage: String?
    var eventHandler: ((_ event: Event) -> Void)?
    
    func getForeCast(location: Location) {
        self.eventHandler?(.loading)
        let calender = Calendar.current
        
        APIManager.shared.request(apiRouter: WeatherAPIRouter.getFiveDaysForecast(lat: location.lat, lon: location.lon), modelType: FiveDaysForecastModel.self) { reponse in
            self.eventHandler?(.stopLoading)
            
            let todaysDate = Date.now
            switch reponse {
            case .success(let result): result.list.forEach { data in
                let dtoDate = self.getKey(day: data.dtTxt)
                let tempDTO = (ForecastDTO(weatherType: data.weather.first?.main ?? "ClearSky", date: data.dtTxt, temp: data.main.temp, icon: data.weather.first?.icon ?? "01"))
                
                switch calender.dateComponents([.day], from: todaysDate, to: dtoDate).day {
                case 0: self.todayForecast.append(tempDTO)
                case 1: self.addDatatoForeCast(id: 0, data: tempDTO)
                case 2: self.addDatatoForeCast(id: 1, data: tempDTO)
                case 3: self.addDatatoForeCast(id: 2, data: tempDTO)
                case 4: self.addDatatoForeCast(id: 3, data: tempDTO)
                default: break
                }
            }
                
                self.eventHandler?(.dataLoaded)
                
            case .failure(let error):
                self.forecastErrorMessage = error.localizedDescription
                self.eventHandler?(.error(error))
            }
        }
    }
    
    func addDatatoForeCast(id: Int, data: ForecastDTO) {
        if self.nextFourDaysForecast.keys.contains(id) {
            self.nextFourDaysForecast[id]!.append(data)
        }
        else {
            self.nextFourDaysForecast[id] = [data]
        }
        
    }
}

extension ForecastWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}

extension ForecastWeatherVM {
    func getKey(day: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: day)!
    }
}
