//
//  LocationRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

class LocationRepository: LocationRepositoryInterface {
    private var locations: [Location] = []
    
    func addLocation(_ location: Location) throws {
        // Agrega una ubicación al array
        locations.append(location)
        try saveLocations()
    }
    
    func getLocation(byId id: String) -> Location? {
        return locations.first { $0.id == id }
    }
    
    func getAllLocations() -> [Location] {
        return locations
    }
    
    func deleteLocation(byId id: String) throws {
        if let index = locations.firstIndex(where: { $0.id == id }) {
            locations.remove(at: index)
            try saveLocations()
        }
    }
    
    func fetchLocations() -> [Location] {
        // Implementación para obtener ubicaciones
        return []
    }
    
    func getLocations() -> [Location] {
        return locations
    }

    func saveLocation(_ location: Location) throws {
        locations.append(location)
    }
    
    func saveLocations() throws {
        // Guarda las ubicaciones en almacenamiento persistente (ej. UserDefaults o Core Data)
    }
    
    func loadLocations() throws {
        // Carga las ubicaciones desde almacenamiento persistente
    }
}

