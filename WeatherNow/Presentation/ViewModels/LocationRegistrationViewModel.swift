//
//  LocationRegistrationViewModel.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

class LocationRegistrationViewModel {
    
    // MARK: - Properties
    
    private let locationRepository: LocationRepositoryInterface
    var onSaveSuccess: (() -> Void)?
    var onSaveError: ((Error) -> Void)?
    
    // MARK: - Initialization
    
    init(locationRepository: LocationRepositoryInterface) {
        self.locationRepository = locationRepository
    }
    
    // MARK: - Public Methods
    
    func generateNewId() -> String {
        return UUID().uuidString
    }
    
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date())
    }
    
    func saveLocation(cityName: String, latitude: String, longitude: String) {
        let id = generateNewId()
        let registrationDate = currentDate()
        let location = Location(id: id, cityName: cityName, latitude: latitude, longitude: longitude, registrationDate: registrationDate)
        
        do {
            try locationRepository.saveLocation(location)
            onSaveSuccess?()
        } catch {
            onSaveError?(error)
        }
    }
}


