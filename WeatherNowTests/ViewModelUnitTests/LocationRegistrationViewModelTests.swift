//
//  LocationRegistrationViewModelTests.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import XCTest
@testable import WeatherNow

final class LocationRegistrationViewModelTests: XCTestCase {

    var viewModel: LocationRegistrationViewModel!
    var mockWeatherRepository: MockWeatherRepository!
    var mockLocationRepository: MockLocationRepository!
    var mockNotificationService: MockWeatherNotificationService!

    override func setUp() {
        super.setUp()
        mockWeatherRepository = MockWeatherRepository()
        mockLocationRepository = MockLocationRepository()
        mockNotificationService = MockWeatherNotificationService(notificationService: NotificationService()) 
        viewModel = LocationRegistrationViewModel(locationRepository: mockLocationRepository,
                                                  weatherRepository: mockWeatherRepository,
                                                  notificationService: mockNotificationService)
    }

    override func tearDown() {
        viewModel = nil
        mockWeatherRepository = nil
        mockLocationRepository = nil
        mockNotificationService = nil
        super.tearDown()
    }

    // Test registering a location with valid coordinates
    func testRegisterLocationWithValidCoordinates() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Valid City", latitude: 12.34, longitude: 56.78)

        let expectation = self.expectation(description: "Location registered successfully")
        viewModel.onLocationRegistered = {
            expectation.fulfill()
        }

        // Act
        viewModel.registerLocation(location: location)

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(mockLocationRepository.addLocationCalled)
        XCTAssertTrue(mockNotificationService.checkForSignificantWeatherChangeCalled)
    }

    // Test registering a location with invalid coordinates
    func testRegisterLocationWithInvalidCoordinates() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Invalid City", latitude: 0.0, longitude: 0.0)

        let expectation = self.expectation(description: "Location registration failed")
        viewModel.onLocationFail = {
            expectation.fulfill()
        }

        // Act
        viewModel.registerLocation(location: location)

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertFalse(mockLocationRepository.addLocationCalled)
        XCTAssertFalse(mockNotificationService.checkForSignificantWeatherChangeCalled)
    }

    // Test registering a location by city name
    func testRegisterLocationWithCityName() {
        // Arrange
        let cityName = "Test City"

        let expectation = self.expectation(description: "Location registered successfully")
        viewModel.onLocationRegistered = {
            expectation.fulfill()
        }

        // Act
        viewModel.registerLocation(cityName: cityName)

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(mockLocationRepository.addLocationCalled)
    }

    // Test failing to register a location by city name
    func testRegisterLocationWithCityNameFailure() {
        // Arrange
        let cityName = "Test City"
        mockWeatherRepository.shouldFail = true

        let expectation = self.expectation(description: "Location registration failed")
        viewModel.onLocationFail = {
            expectation.fulfill()
        }

        // Act
        viewModel.registerLocation(cityName: cityName)

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertFalse(mockLocationRepository.addLocationCalled)
    }
}

