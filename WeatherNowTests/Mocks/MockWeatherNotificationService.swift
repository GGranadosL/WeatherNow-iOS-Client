//
//  MockWeatherNotificationService.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import Foundation
@testable import WeatherNow

class MockWeatherNotificationService: WeatherNotificationService {
    
    var checkForSignificantWeatherChangeCalled = false
    
    override func checkForSignificantWeatherChange(previousWeather: LocationEntity, currentWeather: LocationEntity) {
        checkForSignificantWeatherChangeCalled = true

    }
}

