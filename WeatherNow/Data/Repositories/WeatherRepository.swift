//
//  WeatherRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

/// A repository that fetches weather data from an API using the APIClient.
class WeatherRepository: WeatherRepositoryInterface {
    func fetchWeather(forCity cityName: String, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        apiClient.fetchWeather(forCity: cityName) { result in
            switch result {
            case .success(let location):
                completion(.success(location))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    private let apiClient: APIClientInterface
    
    // Initializes the repository with an API client.
    init(apiClient: APIClientInterface) {
        self.apiClient = apiClient
    }
    
    // Fetches weather data for a given location.
    func fetchWeather(forLocation location: LocationEntity, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        apiClient.fetchWeather(forLocation: location) { result in
            switch result {
            case .success(let updatedLocation):
                var resultLocation = location
                resultLocation.cityName = updatedLocation.cityName 
                resultLocation.temperature = updatedLocation.temperature
                resultLocation.conditions = updatedLocation.conditions
                resultLocation.icon = updatedLocation.icon
                completion(.success(resultLocation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

    



