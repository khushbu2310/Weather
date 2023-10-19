//
//  CDCurrentWeatherDTO.swift
//  Weather
//
//  Created by Khushbuben Patel on 18/10/23.
//

import Foundation

extension CDCurrentWeather {
    func toConvert() -> CurrentWeatherDTO {
        return CurrentWeatherDTO(weatherType: self.weatherType!,
                                 city: self.city!,
                                 temp: self.temp!,
                                 humidity: self.humidity!,
                                 wind: self.wind!,
                                 icon: self.icon!,
                                 lat: self.lat!,
                                 lon: self.lon!)
    }
}
