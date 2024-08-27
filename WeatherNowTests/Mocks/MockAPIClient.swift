//
//  MockAPIClient.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import Foundation
@testable import WeatherNow

/// Mock API client that simulates the behavior of a real API client for testing purposes.
class MockAPIClient: APIClientInterface {
    
    // Flags to track if the methods were called
    var fetchWeatherForLocationCalled = false
    var fetchWeatherForCityCalled = false
    
    // Controls whether the mock client should simulate a failure
    var shouldFail = false
    
    // Mock data to return in the success case
    var mockWeatherData: LocationEntity?
    
    /// Simulates fetching weather data for a specific location (latitude and longitude).
    /// - Parameters:
    ///   - location: The `LocationEntity` containing latitude and longitude.
    ///   - completion: A closure that returns the result of the simulated fetch.
    func fetchWeather(forLocation location: LocationEntity, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        // Indicate that this method was called
        fetchWeatherForLocationCalled = true
        
        // Simulate failure or success based on the state of `shouldFail` and `mockWeatherData`
        if shouldFail {
            completion(.failure(NSError(domain: "MockAPIClientError", code: -1, userInfo: nil)))
        } else if let mockWeatherData = mockWeatherData {
            completion(.success(mockWeatherData))
        } else {
            completion(.failure(NSError(domain: "MockAPIClientError", code: -2, userInfo: nil)))
        }
    }
    
    /// Simulates fetching weather data for a specific city by name.
    /// - Parameters:
    ///   - cityName: The name of the city.
    ///   - completion: A closure that returns the result of the simulated fetch.
    func fetchWeather(forCity cityName: String, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        // Indicate that this method was called
        fetchWeatherForCityCalled = true
        
        // Simulate failure or success based on the state of `shouldFail` and `mockWeatherData`
        if shouldFail {
            completion(.failure(NSError(domain: "MockAPIClientError", code: -1, userInfo: nil)))
        } else if let mockWeatherData = mockWeatherData {
            completion(.success(mockWeatherData))
        } else {
            completion(.failure(NSError(domain: "MockAPIClientError", code: -2, userInfo: nil)))
        }
    }
}


