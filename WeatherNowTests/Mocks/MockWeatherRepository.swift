//
//  MockWeatherRepository.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import Foundation
@testable import WeatherNow

class MockWeatherRepository: WeatherRepositoryInterface {
    
    // Properties to track function calls
    var fetchWeatherCalled = false
    var shouldFail = false
    
    func fetchWeather(forLocation location: LocationEntity, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        fetchWeatherCalled = true
        
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        } else {
            // Return a mocked successful response
            let updatedLocation = LocationEntity(id: location.id, cityName: location.cityName, latitude: location.latitude, longitude: location.longitude)
            completion(.success(updatedLocation))
        }
    }
    
    func fetchWeather(forCity cityName: String, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        fetchWeatherCalled = true
        
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        } else {
            // Return a mocked successful response
            let location = LocationEntity(id: UUID(), cityName: cityName, latitude: 12.34, longitude: 56.78)
            completion(.success(location))
        }
    }
}

