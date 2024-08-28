//
//  LocationRepositoryTests.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import XCTest
@testable import WeatherNow

final class LocationRepositoryTests: XCTestCase {

    var locationRepository: LocationRepository!
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Create a new UserDefaults suite for testing
        userDefaults = UserDefaults(suiteName: "TestSuite")
        
        // Ensure it's clean before every test
        userDefaults.removePersistentDomain(forName: "TestSuite")
        
        // Inject the test UserDefaults into the repository
        locationRepository = LocationRepository(userDefaults: userDefaults)
        
        // Limpia todas las ubicaciones antes de cada prueba
        locationRepository.clearAllLocations()
    }

    override func tearDown() {
        locationRepository = nil
        super.tearDown()
        userDefaults?.removePersistentDomain(forName: "TestSuite")
    }

    func testAddLocation() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Test City", latitude: 12.34, longitude: 56.78)
        
        // Act
        locationRepository.addLocation(location)
        let storedLocations = locationRepository.getLocations()
        
        // Assert
        XCTAssertEqual(storedLocations.count, 1)
        XCTAssertEqual(storedLocations.first?.cityName, "Test City")
    }

    func testGetLocations() {
        // Arrange
        let location1 = LocationEntity(id: UUID(), cityName: "City One", latitude: 12.34, longitude: 56.78)
        let location2 = LocationEntity(id: UUID(), cityName: "City Two", latitude: 23.45, longitude: 67.89)
        locationRepository.addLocation(location1)
        locationRepository.addLocation(location2)
        
        // Act
        let storedLocations = locationRepository.getLocations()
        
        // Assert
        XCTAssertEqual(storedLocations.count, 2)
        XCTAssertEqual(storedLocations[0].cityName, "City One")
        XCTAssertEqual(storedLocations[1].cityName, "City Two")
    }

    func testDeleteLocation() {
        // Arrange
        let location = LocationEntity(id: UUID(), cityName: "Delete City", latitude: 12.34, longitude: 56.78)
        locationRepository.addLocation(location)
        
        // Act
        let indexToDelete = 0
        locationRepository.deleteLocation(at: indexToDelete)
        let storedLocations = locationRepository.getLocations()
        
        // Assert
        XCTAssertEqual(storedLocations.count, 0)
    }

    func testClearInvalidLocations() {
        // Arrange
        let invalidLocation = LocationEntity(id: UUID(), cityName: "", latitude: 12.34, longitude: 56.78)
        let validLocation = LocationEntity(id: UUID(), cityName: "Valid City", latitude: 23.45, longitude: 67.89)
        locationRepository.addLocation(invalidLocation)
        locationRepository.addLocation(validLocation)
        
        // Act
        locationRepository.clearInvalidLocations()
        let storedLocations = locationRepository.getLocations()
        
        // Assert
        XCTAssertEqual(storedLocations.count, 1)
        XCTAssertEqual(storedLocations.first?.cityName, "Valid City")
    }
}
