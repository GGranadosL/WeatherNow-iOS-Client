//
//  APIClient.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 25/08/24.
//

import Foundation

// API client for fetching weather data from a remote service.
class APIClient: WeatherRepositoryInterface {
    
    /// Retrieves the API key from the Keychain.
    /// - Returns: The API key as a String.
   // private func getAPIKeyFromKeychain() -> String {
        // Implement Keychain access here to securely retrieve the API key.
        // For demonstration purposes, returning a hardcoded value.
   //     return "a5f8704cc91234ed73362e270c5eb343"
   // }

    
    private let apiKey = "a5f8704cc91234ed73362e270c5eb343" //KeychainHelper.shared.getAPIKey() // Retrieves the API key from the Keychain.
    
    // Fetches weather data for a specified location.
    func fetchWeather(forLocation location: LocationEntity, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        guard let url = buildURL(for: location) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                var updatedLocation = location
                updatedLocation.cityName = weatherResponse.name
                updatedLocation.temperature = weatherResponse.main.temp
                updatedLocation.conditions = weatherResponse.weather.first?.main ?? ""
                updatedLocation.conditionsDetail = weatherResponse.weather.first?.description ?? ""
                updatedLocation.icon = weatherResponse.weather.first?.icon ?? ""
                updatedLocation.humidity = weatherResponse.main.humidity
                updatedLocation.pressure = weatherResponse.main.pressure
                updatedLocation.windSpeed = weatherResponse.wind.speed
                completion(.success(updatedLocation))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Constructs the URL for the weather API request.
    private func buildURL(for location: LocationEntity) -> URL? {
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        let urlString = "\(baseURL)?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)"
        return URL(string: urlString)
    }
    
    // Defines possible API errors.
    enum APIError: Error {
        case invalidURL
        case noData
    }
}

