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
    
    let locations: Bindable<[LocationEntity]> = Bindable([])
    private let locationManager = CLLocationManager()
    private let weatherRepository: WeatherRepositoryInterface
    
    // Default location in case user denies access
    private let defaultLocation = LocationEntity(id: UUID(), cityName: "New York", latitude: 40.7128, longitude: -74.0060, registrationDate: Date(), temperature: 295.2)
    
    private var hasAddedCurrentLocation = false // To track if "Current Location" has been added

    // MARK: - Initialization
    
    init(weatherRepository: WeatherRepositoryInterface) {
        self.weatherRepository = weatherRepository
        super.init()
        locationManager.delegate = self
        requestLocation()
    }
    
    // MARK: - Public Methods
    
    func addLocation(_ location: LocationEntity) {
        var currentLocations = locations.value
        
        if location.cityName == "Current Location" {
            if hasAddedCurrentLocation {
                return
            }
            hasAddedCurrentLocation = true
        }
        
        if !currentLocations.contains(where: { $0.id == location.id }) {
            currentLocations.insert(location, at: 0)
            locations.value = currentLocations
            fetchWeather(for: location)
        }
    }
    
    func fetchWeather(for location: LocationEntity) {
        weatherRepository.fetchWeather(forLocation: location) { [weak self] result in
            switch result {
            case .success(let updatedLocation):
                self?.updateWeatherData(with: updatedLocation)
            case .failure(let error):
                print("Failed to fetch weather: \(error)")
            }
        }
    }
    
    private func updateWeatherData(with updatedLocation: LocationEntity) {
        if let index = locations.value.firstIndex(where: { $0.id == updatedLocation.id }) {
            locations.value[index] = updatedLocation
            locations.notifyListeners() // Notificar el cambio para actualizar la vista
        } else {
            locations.value.append(updatedLocation)
        }
    }
    
    func loadWeatherData() {
        if let currentLocationWeather = locations.value.first(where: { $0.cityName == "Current Location" }) {
            locations.value.insert(currentLocationWeather, at: 0)
        } else {
            addLocation(defaultLocation)
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
        let locationEntity = LocationEntity(id: UUID(), cityName: "", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, registrationDate: Date())
        addLocation(locationEntity) // Esto desencadena la obtención del clima y actualiza el nombre de la ciudad
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
        addLocation(defaultLocation)
    }
}
