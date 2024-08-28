//
//  WeatherRepositoryIntegrationTests.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import XCTest
@testable import WeatherNow

class WeatherRepositoryIntegrationTests: XCTestCase {
    
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
    
    func testFetchWeatherForLocation_Success() {
        // Arrange
        let expectedLocation = LocationEntity(id: UUID(), cityName: "Test City", latitude: 0.0, longitude: 0.0)
        mockAPIClient.mockWeatherData = expectedLocation
        
        let expectation = self.expectation(description: "Fetch weather data")
        
        // Act
        weatherRepository.fetchWeather(forLocation: expectedLocation) { result in
            switch result {
            case .success(let locationEntity):
                // Assert
                XCTAssertEqual(locationEntity.cityName, "Test City")
            case .failure(let error):
                XCTFail("Expected success but got failure: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(mockAPIClient.fetchWeatherForLocationCalled)
    }

    func testFetchWeatherForLocation_Failure() {
        // Arrange
        mockAPIClient.shouldFail = true
        
        let expectedLocation = LocationEntity(id: UUID(), cityName: "Test City", latitude: 0.0, longitude: 0.0)
        
        let expectation = self.expectation(description: "Fetch weather data")
        
        // Act
        weatherRepository.fetchWeather(forLocation: expectedLocation) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Assert
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(mockAPIClient.fetchWeatherForLocationCalled)
    }
}

