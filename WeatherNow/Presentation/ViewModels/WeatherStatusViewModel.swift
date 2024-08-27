//
//  WeatherStatusViewModel.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//
// ViewModel that manages weather data and user locations, integrating with a local notification service.
import Foundation
import CoreLocation

class WeatherStatusViewModel: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    // Bindable array of LocationEntity objects to track current and user-added locations
    let locations: Bindable<[LocationEntity]> = Bindable([])
    
    private let locationManager = CLLocationManager()
    let weatherRepository: WeatherRepositoryInterface
    let locationRepository: LocationRepositoryInterface
    let notificationService: WeatherNotificationService
    
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
    
    init(weatherRepository: WeatherRepositoryInterface, locationRepository: LocationRepositoryInterface, notificationService: WeatherNotificationService) {
        self.weatherRepository = weatherRepository
        self.locationRepository = locationRepository
        self.notificationService = notificationService
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Public Methods
    
    // Loads weather data for all locations and requests location permissions
    func loadWeatherData() {
        // Load user-added locations from the repository
        userAddedLocations = locationRepository.getLocations()

        // Fetch weather data for each user-added location
        for location in userAddedLocations {
            fetchWeather(for: location, isCurrentLocation: false) { _ in }
        }
        
        // Request location permissions if not already granted
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // Notify listeners about data update
        locations.notifyListeners()
    }

    func addLocation(_ location: LocationEntity, isCurrentLocation: Bool = false) {
        if isCurrentLocation {
            fetchWeather(for: location, isCurrentLocation: true) { _ in }
        }
    }
    
    // Deletes a location from the user-added locations list and updates the repository
    func deleteLocation(at index: Int) {
        guard index >= 0 && index < userAddedLocations.count else { return }
        locationRepository.deleteLocation(at: index)  // Utilizes the index to remove the location
        userAddedLocations.remove(at: index)  // Updates the location list
        locations.notifyListeners()  // Notifies observers about the change
    }
    
    func fetchWeather(for location: LocationEntity, isCurrentLocation: Bool = false, completion: @escaping (Bool) -> Void) {
        weatherRepository.fetchWeather(forLocation: location) { [weak self] result in
            switch result {
            case .success(let updatedLocation):
                if isCurrentLocation {
                    self?.handleCurrentLocationWeatherUpdate(updatedLocation)
                } else {
                    self?.handleUserAddedLocationWeatherUpdate(updatedLocation)
                }
            case .failure(let error):
                print("Error fetching weather data: \(error)")
            }
        }
    }

    private func handleCurrentLocationWeatherUpdate(_ updatedLocation: LocationEntity) {
        let previousWeatherData = notificationService.loadPreviousWeatherData()
        if let previousLocation = currentLocationWeather {
            notificationService.checkForSignificantWeatherChange(
                previousWeather: previousWeatherData[updatedLocation.cityName] ?? previousLocation,
                currentWeather: updatedLocation
            )
        }
        currentLocationWeather = updatedLocation
    }

    private func handleUserAddedLocationWeatherUpdate(_ updatedLocation: LocationEntity) {
        let previousWeatherData = notificationService.loadPreviousWeatherData()
        if let index = userAddedLocations.firstIndex(where: { $0.id == updatedLocation.id }) {
            let previousLocation = userAddedLocations[index]
            notificationService.checkForSignificantWeatherChange(
                previousWeather: previousWeatherData[updatedLocation.cityName] ?? previousLocation,
                currentWeather: updatedLocation
            )
            userAddedLocations[index] = updatedLocation
            locations.notifyListeners()
        }
    }

    
    func fetchWeatherInBackground(completion: @escaping (Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var didUpdate = false
        
        for location in userAddedLocations {
            dispatchGroup.enter()
            fetchWeather(for: location, isCurrentLocation: false) { success in
                if success { didUpdate = true }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(didUpdate)
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
