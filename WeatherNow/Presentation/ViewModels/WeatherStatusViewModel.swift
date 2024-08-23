//
//  WeatherStatusViewModel.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import Foundation

// Define un tipo observable para el WeatherStatusViewModel
class WeatherStatusViewModel {

    // MARK: - Properties

    private let weatherRepository: WeatherRepositoryInterface
    private let locationRepository: LocationRepositoryInterface
    private(set) var locations: Bindable<[Location]>
    private(set) var weatherData: Bindable<[Weather]>

    // MARK: - Initialization

    init(locations: [Location], weatherData: [Weather], weatherRepository: WeatherRepositoryInterface, locationRepository: LocationRepositoryInterface) {
        self.weatherRepository = weatherRepository
        self.locationRepository = locationRepository
        self.locations = Bindable(locations)
        self.weatherData = Bindable(weatherData)
    }

    // MARK: - Methods

    func loadWeatherData() {
        // Asumiendo que `locations` contiene la lista de ubicaciones para las que necesitamos datos meteorológicos
        let locationList = locations.value
        var updatedWeatherData = [Weather]()

        // Usamos un dispatch group para manejar múltiples solicitudes
        let dispatchGroup = DispatchGroup()

        for location in locationList {
            dispatchGroup.enter()
            weatherRepository.fetchWeather(forLocation: location) { result in
                switch result {
                case .success(let weather):
                    updatedWeatherData.append(weather)
                case .failure(let error):
                    print("Error fetching weather data: \(error)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.weatherData.value = updatedWeatherData
        }
    }

    func addLocation(_ location: Location) {
        do {
            try locationRepository.saveLocation(location)
            locations.value.append(location)
            // Trigger a reload of weather data if needed
            loadWeatherData()
        } catch {
            print("Error saving location: \(error)")
        }
    }
}

