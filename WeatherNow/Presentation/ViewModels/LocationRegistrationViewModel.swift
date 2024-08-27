//
//  LocationRegistrationViewModel.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

/// ViewModel for managing the location registration process.
class LocationRegistrationViewModel: NSObject {
    
    // MARK: - Properties
    
    private let locationRepository: LocationRepositoryInterface
    private let weatherRepository: WeatherRepositoryInterface
    private let notificationService: WeatherNotificationService
    
    // Callback to notify when location registration is successful
    var onLocationRegistered: (() -> Void)?
    var onLocationFail: (() -> Void)?
    
    // MARK: - Initialization
    
    init(locationRepository: LocationRepositoryInterface, weatherRepository: WeatherRepositoryInterface, notificationService: WeatherNotificationService) {
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
        self.notificationService = notificationService
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Registers a location using latitude and longitude
    func registerLocation(location: LocationEntity) {
        if location.latitude != 0.0 && location.longitude != 0.0 {
            weatherRepository.fetchWeather(forLocation: location) { [weak self] result in
                switch result {
                case .success(let updatedLocation):
                    self?.locationRepository.addLocation(updatedLocation)
                    self?.onLocationRegistered?()
                    
                    // Check for significant weather changes and trigger a notification if necessary
                    self?.notificationService.checkForSignificantWeatherChange(previousWeather: location, currentWeather: updatedLocation)
                    
                case .failure(let error):
                    print("Failed to fetch weather data: \(error)")
                }
            }
        } else {
            print("Attempted to register a location with invalid coordinates")
        }
    }


    /// Registers a location using a city name
    func registerLocation(cityName: String) {
        // API call to fetch location data based on city name
        weatherRepository.fetchWeather(forCity: cityName) { [weak self] result in
            switch result {
            case .success(let location):
                self?.locationRepository.addLocation(location)
                self?.onLocationRegistered?() // Notify that the location has been registered
            case .failure(let error):
                self?.onLocationFail?()
                print("Failed to register location by city name: \(error)")
            }
        }
    }
}


