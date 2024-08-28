//
//  MockLocationRepository.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import Foundation
@testable import WeatherNow

class MockLocationRepository: LocationRepositoryInterface {
    
    // Properties to track function calls
    var addLocationCalled = false
    var deleteLocationCalled = false
    
    // Mock data storage
    var locations: [LocationEntity] = []
    
    func getLocations() -> [LocationEntity] {
        return locations
    }
    
    func addLocation(_ location: LocationEntity) {
        addLocationCalled = true
        locations.append(location)
    }
    
    func deleteLocation(at index: Int) {
        deleteLocationCalled = true
        if index < locations.count {
            locations.remove(at: index)
        }
    }
    
    func clearInvalidLocations() {
        // Implement if needed for tests
    }
}



