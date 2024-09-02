//
//  LocationRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

/// A repository that CRUD location/weather data from persisted data.
class LocationRepository: LocationRepositoryInterface {
    
    private let locationsKey = "weatherLocations" // Key used to store locations in UserDefaults
    private var locations: [LocationEntity] = [] // Array to store the location entities
    
    var userDefaults: UserDefaults
    
    // Initializes the repository with UserDefaults. Defaults to the standard UserDefaults.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadLocations() // Load the locations from UserDefaults when the repository is initialized
    }
    
    // Loads the locations from UserDefaults and decodes them into LocationEntity objects
    private func loadLocations() {
        if let data = userDefaults.data(forKey: locationsKey),
           let decodedLocations = try? JSONDecoder().decode([LocationEntity].self, from: data) {
            locations = decodedLocations
        }
    }

    // Saves the current locations array to UserDefaults by encoding it into data
    private func saveLocations() {
        if let encodedData = try? JSONEncoder().encode(locations) {
            userDefaults.set(encodedData, forKey: locationsKey)
        }
    }
    
    // Adds a new location to the repository, clears any invalid locations, and saves the updated list
    func addLocation(_ location: LocationEntity) {
        locations.append(location)
        clearInvalidLocations()
        saveLocations()
    }
    
    // Returns all the stored locations
    func getLocations() -> [LocationEntity] {
        return locations
    }

    // Deletes a location at a specific index, and saves the updated list
    func deleteLocation(at index: Int) {
        guard index >= 0 && index < locations.count else { return }
        locations.remove(at: index)
        saveLocations()
    }
    
    // Deletes a specific location by matching the ID, and saves the updated list
    func deleteLocation(_ location: LocationEntity) {
        locations.removeAll { $0.id == location.id }
        saveLocations()
    }
    
    // Clears locations with an empty city name, and saves the updated list
    internal func clearInvalidLocations() {
        locations = locations.filter { !$0.cityName.isEmpty }
        saveLocations()
    }
    
    // Clears all locations from the repository and saves the empty list
    func clearAllLocations() {
        locations.removeAll()
        saveLocations()
    }
}






