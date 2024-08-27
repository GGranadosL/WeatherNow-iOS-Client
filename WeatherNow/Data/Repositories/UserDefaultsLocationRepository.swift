//
//  LocationRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

// Manages location data using UserDefaults.
class UserDefaultsLocationRepository: LocationRepositoryInterface {
    
    private let defaults = UserDefaults.standard
    private let key = "locations"
    
    // Adds a new location if not already present.
    func addLocation(_ location: LocationEntity) {
        var locations = getLocations()
        if !locations.contains(where: { $0.id == location.id }) {
            locations.append(location)
            saveLocations(locations)
        }
    }
    
    // Retrieves all stored locations.
    func getLocations() -> [LocationEntity] {
        guard let data = defaults.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([LocationEntity].self, from: data)) ?? []
    }
    
    // Saves the list of locations to UserDefaults.
    private func saveLocations(_ locations: [LocationEntity]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(locations) {
            defaults.set(data, forKey: key)
        }
    }
}




