//
//  LocationRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

class LocationRepository: LocationRepositoryInterface {
    
    private let locationsKey = "weatherLocations"
    private var locations: [LocationEntity] = []
    
    var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadLocations()
    }
    
    private func loadLocations() {
        if let data = userDefaults.data(forKey: locationsKey),
           let decodedLocations = try? JSONDecoder().decode([LocationEntity].self, from: data) {
            locations = decodedLocations
        }
    }

    private func saveLocations() {
        if let encodedData = try? JSONEncoder().encode(locations) {
            userDefaults.set(encodedData, forKey: locationsKey)
        }
    }
    
    func addLocation(_ location: LocationEntity) {
        locations.append(location)
        clearInvalidLocations()
        saveLocations()
    }
    
    func getLocations() -> [LocationEntity] {
        return locations
    }

    func deleteLocation(at index: Int) {
        guard index >= 0 && index < locations.count else { return }
        locations.remove(at: index)
        saveLocations()
    }
    
    func deleteLocation(_ location: LocationEntity) {
        locations.removeAll { $0.id == location.id }
        saveLocations()
    }
    
    internal func clearInvalidLocations() {
        locations = locations.filter { !$0.cityName.isEmpty }
        saveLocations()
    }
    
    func clearAllLocations() {
        locations.removeAll()
        saveLocations()
    }
}

    





