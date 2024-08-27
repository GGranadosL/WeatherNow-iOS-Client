//
//  WeatherStatusViewModel.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import Foundation
import CoreLocation

class WeatherStatusViewModel: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    // Bindable array of LocationEntity objects to track current and user-added locations
    let locations: Bindable<[LocationEntity]> = Bindable([])
    
    private let locationManager = CLLocationManager()
    let weatherRepository: WeatherRepositoryInterface
    let locationRepository: LocationRepositoryInterface
    
    // Stores the current location's weather information if available
    var currentLocationWeather: LocationEntity? {
        didSet {
            locations.notifyListeners()
        }
    }
    
    // Stores locations added by the user
    var userAddedLocations: [LocationEntity] = [] {
        didSet {
            locations.notifyListeners()
        }
    }
    
    // Checks if the current location weather is available
    var hasCurrentLocationWeather: Bool {
        return currentLocationWeather != nil
    }

    // MARK: - Initialization
    
    init(weatherRepository: WeatherRepositoryInterface, locationRepository: LocationRepositoryInterface) {
        self.weatherRepository = weatherRepository
        self.locationRepository = locationRepository
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Public Methods
    
    func loadWeatherData() {
        // Load user-added locations from the repository
        userAddedLocations = locationRepository.getLocations()

        // Fetch weather data for each user-added location
        for location in userAddedLocations {
            fetchWeather(for: location, isCurrentLocation: false)
        }
        
        // Request location permissions if not already granted
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // Notify listeners about data update
        locations.notifyListeners()
    }
    
    // Adds a location to the appropriate list, fetching weather data
    func addLocation(_ location: LocationEntity, isCurrentLocation: Bool = false) {
        if isCurrentLocation {
            fetchWeather(for: location, isCurrentLocation: true)
        }
    }
    
    // Deletes a location from the user-added locations list and updates the repository
    func deleteLocation(at index: Int) {
        guard index >= 0 && index < userAddedLocations.count else { return }
        locationRepository.deleteLocation(at: index)  // Utiliza el índice para eliminar la ubicación
        userAddedLocations.remove(at: index)  // Actualiza la lista de ubicaciones
        locations.notifyListeners()  // Notifica a los observadores sobre el cambio
    }
    
    // Fetches weather data for a given location
    private func fetchWeather(for location: LocationEntity, isCurrentLocation: Bool = false) {
        weatherRepository.fetchWeather(forLocation: location) { [weak self] result in
            switch result {
            case .success(let updatedLocation):
                if isCurrentLocation {
                    self?.currentLocationWeather = updatedLocation
                }
            case .failure(let error):
                print("Error fetching weather data: \(error)")
            }
        }
    }

    // MARK: - Location Handling
    
    private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let locationEntity = LocationEntity(
            id: UUID(),
            cityName: "",
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            registrationDate: Date()
        )
        addLocation(locationEntity, isCurrentLocation: true)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
}
