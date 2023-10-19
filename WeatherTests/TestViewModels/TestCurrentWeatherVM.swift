//
//  TestCurrentWeatherVM.swift
//  WeatherTests
//
//  Created by Khushbuben Patel on 19/10/23.
//

import Foundation
import XCTest
@testable import Weather

final class TestCurrentWeatherVM: XCTestCase {

    private var currentWeatherVM: CurrentWeatherVM!
    private var mockApi: MockWeatherAPI!
    
        
    override func setUp()  {
        super.setUp()
        mockApi = MockWeatherAPI()
        currentWeatherVM = CurrentWeatherVM(_repository: mockApi)
    }

    override func tearDown()  {
        mockApi = nil
        currentWeatherVM = nil
        super.tearDown()
    }

    func test_CurrVM_With_Success(){
        let input = CurrentWeatherDTO(weatherType: "Clear", city: "Chikhli", temp: "33.01", humidity: "40", wind: "3.08", icon: "01", lat: "20.7599", lon: "73.0569")
        mockApi.getCurrentWeatherResult = .success(input)
        
        currentWeatherVM.getCurrentWeather(location: LocationModel(lat: "20.759899", lon: "73.056900"))
        
        XCTAssertNotNil(currentWeatherVM.currentWeatherDTO)
        XCTAssertEqual(input.lat, currentWeatherVM.currentWeatherDTO?.lat)
        
    }

    func test_CurrVM_With_Failure(){
        mockApi.getCurrentWeatherResult = .failure(.serverError)
        
        currentWeatherVM.getCurrentWeather(location: LocationModel(lat: "", lon: ""))
        
        XCTAssertNil(currentWeatherVM.currentWeatherDTO)
        
    }

}

