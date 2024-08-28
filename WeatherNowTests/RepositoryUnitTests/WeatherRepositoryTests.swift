//
// WeatherRepositoryTests.swift
// WeatherNowTests
//
// Created by Gerardo Granados Lopez on 27/08/24.
//

import XCTest
@testable import WeatherNow

/// Test suite for WeatherRepository.
final class WeatherRepositoryTests: XCTestCase {
    
    var weatherRepository: WeatherRepository!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        weatherRepository = WeatherRepository(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        weatherRepository = nil
        mockAPIClient = nil
        super.tearDown()
    }
    
    func testFetchWeatherForLocationSuccess() {
        // Arrange
        let expectedLocation = LocationEntity(id: UUID(), cityName: "Test City", latitude: 12.34, longitude: 56.78)
        mockAPIClient.mockWeatherData = expectedLocation
        
        let expectation = self.expectation(description: "FetchWeatherSuccess")
        
        // Act
        weatherRepository.fetchWeather(forLocation: expectedLocation) { result in
            switch result {
            case .success(let location):
                // Assert
                XCTAssertEqual(location.cityName, expectedLocation.cityName)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchWeatherForLocationFailure() {
        // Arrange
        mockAPIClient.shouldFail = true
        
        let expectation = self.expectation(description: "FetchWeatherFailure")
        
        // Act
        weatherRepository.fetchWeather(forLocation: LocationEntity(id: UUID(), cityName: "Test City", latitude: 12.34, longitude: 56.78)) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                // Assert
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchWeatherForCitySuccess() {
        // Arrange
        let expectedLocation = LocationEntity(id: UUID(), cityName: "Test City", latitude: 12.34, longitude: 56.78)
        mockAPIClient.mockWeatherData = expectedLocation
        
        let expectation = self.expectation(description: "FetchWeatherForCitySuccess")
        
        // Act
        weatherRepository.fetchWeather(forCity: "Test City") { result in
            switch result {
            case .success(let location):
                // Assert
                XCTAssertEqual(location.cityName, expectedLocation.cityName)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchWeatherForCityFailure() {
        // Arrange
        mockAPIClient.shouldFail = true
        
        let expectation = self.expectation(description: "FetchWeatherForCityFailure")
        
        // Act
        weatherRepository.fetchWeather(forCity: "Test City") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                // Assert
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
