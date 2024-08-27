//
//  LocationRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

class LocationRepository: LocationRepositoryInterface {
    
    private let locationsKey = "locations"
    private var locations: [LocationEntity] = []
    
    init() {
        loadLocations()
    }
    
    // Carga las ubicaciones almacenadas desde UserDefaults
    private func loadLocations() {
        if let data = UserDefaults.standard.data(forKey: locationsKey),
           let decodedLocations = try? JSONDecoder().decode([LocationEntity].self, from: data) {
            locations = decodedLocations
        }
    }
    
    // Guarda las ubicaciones en UserDefaults
    private func saveLocations() {
        if let encodedData = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(encodedData, forKey: locationsKey)
        }
    }
    
    // Método para agregar una nueva ubicación
    func addLocation(_ location: LocationEntity) {
        locations.append(location)
        saveLocations()
    }
    
    // Método para obtener todas las ubicaciones
    func getLocations() -> [LocationEntity] {
        return locations
    }
    
    // Implementación del método deleteLocation(at:) para eliminar una ubicación por índice
    func deleteLocation(at index: Int) {
        guard index >= 0 && index < locations.count else { return }
        locations.remove(at: index)
        saveLocations() // Actualiza UserDefaults después de eliminar
    }
    
    // Implementación opcional para eliminar por entidad de ubicación en lugar de por índice
    func deleteLocation(_ location: LocationEntity) {
        locations.removeAll { $0.id == location.id }
        saveLocations()
    }
    
    // Delete invalid data
    func clearInvalidLocations() {
        var locations = getLocations()
        locations = locations.filter { !$0.cityName.isEmpty }
        saveLocations()
    }
}

    





