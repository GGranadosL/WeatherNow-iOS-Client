// WeatherStatusViewModelTests.swift
// WeatherNowTests

import XCTest
@testable import WeatherNow

final class WeatherStatusViewModelTests: XCTestCase {

    var viewModel: WeatherStatusViewModel!
    var mockWeatherRepository: MockWeatherRepository!
    var mockLocationRepository: MockLocationRepository!
    var mockNotificationService: MockWeatherNotificationService!
    var mockCalendarService: MockCalendarService!

    override func setUp() {
        super.setUp()
        mockWeatherRepository = MockWeatherRepository()
        mockLocationRepository = MockLocationRepository()
        mockNotificationService = MockWeatherNotificationService(notificationService: NotificationService())
        mockCalendarService = MockCalendarService()
        viewModel = WeatherStatusViewModel(calendarService: mockCalendarService,
                                           weatherRepository: mockWeatherRepository,
                                           locationRepository: mockLocationRepository,
                                           notificationService: mockNotificationService)
    }

    override func tearDown() {
        viewModel = nil
        mockWeatherRepository = nil
        mockLocationRepository = nil
        mockNotificationService = nil
        mockCalendarService = nil
        super.tearDown()
    }

    func testLoadWeatherData() {
        // Arrange
        let mockLocations = [LocationEntity(id: UUID(), cityName: "Test City", latitude: 0.0, longitude: 0.0)]
        mockLocationRepository.locations = mockLocations

        // Act
        viewModel.loadWeatherData()

        // Assert
        XCTAssertEqual(viewModel.userAddedLocations.count, 1)
        XCTAssertTrue(mockWeatherRepository.fetchWeatherCalled)
        XCTAssertTrue(viewModel.locations.didNotify)
    }

    func testAddLocation() {
        // Arrange
        let newLocation = LocationEntity(id: UUID(), cityName: "New City", latitude: 0.0, longitude: 0.0)

        // Act
        viewModel.addLocation(newLocation)

        // Assert
        XCTAssertEqual(viewModel.userAddedLocations.first?.cityName, "New City")
        XCTAssertTrue(viewModel.locations.didNotify)
    }

    func testDeleteLocation() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Delete City", latitude: 0.0, longitude: 0.0)
        viewModel.userAddedLocations = [location]
        mockLocationRepository.locations = [location]  // Populate the mock repository

        // Act
        viewModel.deleteLocation(at: 0)

        // Assert
        XCTAssertEqual(viewModel.userAddedLocations.count, 0)
        XCTAssertTrue(mockLocationRepository.deleteLocationCalled)
        XCTAssertTrue(viewModel.locations.didNotify)
    }

    func testFetchWeather() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Weather City", latitude: 0.0, longitude: 0.0)

        // Act
        viewModel.fetchWeather(for: location, isCurrentLocation: false) { success in
            XCTAssertTrue(success)
        }

        // Assert
        XCTAssertTrue(mockWeatherRepository.fetchWeatherCalled)
    }

    func testHandleCurrentLocationWeatherUpdate() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Current City", latitude: 0.0, longitude: 0.0)
        viewModel.currentLocationWeather = location

        // Act
        viewModel.handleCurrentLocationWeatherUpdate(location)

        // Assert
        XCTAssertEqual(viewModel.currentLocationWeather?.cityName, "Current City")
        XCTAssertTrue(mockNotificationService.checkForSignificantWeatherChangeCalled)
    }

    func testHandleUserAddedLocationWeatherUpdate() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "User City", latitude: 0.0, longitude: 0.0)
        viewModel.userAddedLocations = [location]

        // Act
        viewModel.handleUserAddedLocationWeatherUpdate(location)

        // Assert
        XCTAssertEqual(viewModel.userAddedLocations.first?.cityName, "User City")
        XCTAssertTrue(mockNotificationService.checkForSignificantWeatherChangeCalled)
    }

    func testFetchWeatherInBackground() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Background City", latitude: 0.0, longitude: 0.0)
        viewModel.userAddedLocations = [location]

        // Act
        viewModel.fetchWeatherInBackground { didUpdate in
            XCTAssertTrue(didUpdate)
        }

        // Assert
        XCTAssertTrue(mockWeatherRepository.fetchWeatherCalled)
    }
}
