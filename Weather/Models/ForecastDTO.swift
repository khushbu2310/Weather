//
//  ForecastDTO.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

struct forecastByDays {
    let date:String
    let data:[ForecastDTO]
}
struct ForecastDTO {
    let date:String
    let weatherType:String
    let time:String
    let temp:String
    let icon:String
    
    init(weatherType:String,date:String,temp:Double,icon:String){
        self.temp = String(temp).appending("c")
        self.time = getTime(date: date)
        self.weatherType = weatherType
        self.icon = icon
        self.date = date
    }
    
    func getURL()->URL{
        return URL(string:"https://openweathermap.org/img/wn/\(self.icon)@2x.png")!
    }
    
    func arragedByDate(responce : [ForecastDTO]){
        var result = [String:[ForecastDTO]]()
        responce.forEach { obj in
            result[obj.date]?.append(obj)
        }
    }
}

