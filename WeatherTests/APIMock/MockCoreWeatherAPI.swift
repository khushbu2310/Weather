//
//  MockCoreWeatherAPI.swift
//  WeatherTests
//
//  Created by Khushbuben Patel on 19/10/23.
//

import Foundation
@testable import Weather

class MockCoreWeatherAPI: CoreRepo {
    
    var currentWeatherDTO: CurrentWeatherDTO!
    var city: String!
    var list: [CurrentWeatherDTO]!
    var result: Result<CurrentWeatherDTO,CoreRepoError>!
    var boolResult: Result<Bool,CoreRepoError>!
    
    func get(city: String) -> Result<Weather.CurrentWeatherDTO, Weather.CoreRepoError> {
        return result
    }
    
    func getList() -> Result<[Weather.CurrentWeatherDTO], Never> {
        return .success(list)
    }
    
    func create(currentWeatherDTO: Weather.CurrentWeatherDTO) -> Result<Bool, Weather.CoreRepoError> {
        return boolResult
    }
    
    func update(currentWeatherDTO: Weather.CurrentWeatherDTO) -> Result<Bool, Weather.CoreRepoError> {
        return boolResult
    }
    
    func delete(city: String) -> Result<Bool, Weather.CoreRepoError> {
        return boolResult
    }

}
