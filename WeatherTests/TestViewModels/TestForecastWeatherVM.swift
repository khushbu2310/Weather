//
//  TestForecastWeatherVM.swift
//  WeatherTests
//
//  Created by Khushbuben Patel on 19/10/23.
//

import Foundation
import XCTest
@testable import Weather

final class TestForecastVM: XCTestCase {

    private var forecastVM: ForecastWeatherVM!
    private var mockAPI: MockWeatherAPI!
    private var cityLocation: LocationModel!
    
    override func setUp()  {
      super.setUp()
        mockAPI = MockWeatherAPI()
        forecastVM = ForecastWeatherVM(_repository: mockAPI)
        cityLocation = LocationModel(lat: "20.759899", lon: "73.056900")
    }

    override func tearDown()  {
        mockAPI = nil
        forecastVM = nil
        cityLocation = nil
        super.tearDown()
    }
    
    func test_Forecast_With_Success(){
        mockAPI.getForecastResult = .success(mockAPI.forecast() ?? [:] )
        
        forecastVM.getForeCast(location: cityLocation)
        
        XCTAssertFalse(forecastVM.forecastData.isEmpty)
        XCTAssertEqual(mockAPI.forecast()?.count, forecastVM.forecastData.count)
    }
    
    func test_Forecast_With_Failure(){
        mockAPI.getForecastResult = .failure(.serverError)
        
        forecastVM.getForeCast(location: cityLocation)
        
        XCTAssertTrue(forecastVM.forecastData.isEmpty)
    }
    
    func test_Forecast_NextFoureDays_Forecast(){
        var data = mockAPI.forecast() ?? [:]
        mockAPI.getForecastResult = .success(data)
        data = data.filter({ $0.key != 0 })
        var newData: [Int:[ForecastDTO]] = [:]
        data.forEach { (key,val) in
            newData[key-1] = val
        }
        
        forecastVM.getForeCast(location: cityLocation)
        let ans = forecastVM.getNextFourDaysForcast()
        
        XCTAssertEqual(newData.keys,ans.keys)
        
    }
}
