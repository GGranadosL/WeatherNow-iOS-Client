//
//  LocationRepositoryInterface.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

// Protocol for managing location data operations.
protocol LocationRepositoryInterface {
    // Adds a new location to the repository.
    func addLocation(_ location: LocationEntity)
    
    // Retrieves all stored locations.
    func getLocations() -> [LocationEntity]
}

