//
//  WeatherRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

/// A repository that fetches weather data from an API using the APIClient.
class WeatherRepository: WeatherRepositoryInterface {

    private let apiClient: APIClient
    
    /// Initializes the repository with an API client.
    /// - Parameter apiClient: The API client used for making network requests.
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    /// Fetches weather data for a given location.
    /// - Parameters:
    ///   - location: The location for which to fetch weather data.
    ///   - completion: A closure that gets called with the result of the request.
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

    



