//
//  LocationRepositoryInterface.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

// Protocol for managing location data operations.
protocol LocationRepositoryInterface {
    /// Adds a new location to the repository.
    /// - Parameter location: The `LocationEntity` object representing the location to be added.
    func addLocation(_ location: LocationEntity)
    
    /// Deletes a location from the repository at a specific index.
    /// - Parameter index: The index of the location to be deleted in the locations array.
    func deleteLocation(at index: Int)
    
    /// Retrieves all stored locations.
    /// - Returns: An array of `LocationEntity` objects representing all the stored locations.
    func getLocations() -> [LocationEntity]
    
    /// Clears invalid locations from the repository, such as those with empty city names.
    func clearInvalidLocations()
}


