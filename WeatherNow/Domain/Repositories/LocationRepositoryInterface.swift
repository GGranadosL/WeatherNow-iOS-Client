//
//  LocationRepositoryInterface.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

protocol LocationRepositoryInterface {
    // CRUD Operations
    func addLocation(_ location: Location) throws
    func getLocation(byId id: String) -> Location?
    func getAllLocations() -> [Location]
    func deleteLocation(byId id: String) throws
    func saveLocation(_ location: Location) throws
    func fetchLocations() -> [Location]
    func getLocations() -> [Location]

    // Persistence Operations
    func saveLocations() throws
    func loadLocations() throws
}

