//
//  LocationRegistrationViewModel.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation
import CoreLocation

/// ViewModel for managing the location registration process.
class LocationRegistrationViewModel: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let locationRepository: LocationRepositoryInterface
    private var locationManager: CLLocationManager?
    
    // Callback to notify when location registration is successful
    var onLocationRegistered: (() -> Void)?
    
    // MARK: - Initialization
    
    init(locationRepository: LocationRepositoryInterface) {
        self.locationRepository = locationRepository
        super.init() // Initialize the superclass (NSObject)
        setupLocationManager()
    }
    
    // MARK: - Private Methods
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func registerLocation(location: LocationEntity) {
        locationRepository.addLocation(location)
        onLocationRegistered?()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let cityName = "" // TODO: Use reverse geocoding to get the city name
        let locationEntity = LocationEntity(cityName: cityName, latitude: location.coordinate.latitude , longitude: location.coordinate.longitude )
        registerLocation(location: locationEntity)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location manager errors
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
