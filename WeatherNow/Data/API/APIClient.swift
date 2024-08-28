//
//  APIClient.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 25/08/24.
//

import Foundation

// API client for fetching weather data from a remote service.
class APIClient: APIClientInterface, WeatherRepositoryInterface {
    
    private let apiKey = KeychainHelper.shared.getAPIKey() // Retrieves the API key from the Keychain.
    
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
                print(weatherResponse)
                var updatedLocation = location
                updatedLocation.cityName = weatherResponse.name
                updatedLocation.temperature = weatherResponse.main.temp
                updatedLocation.conditions = weatherResponse.weather.first?.main ?? ""
                updatedLocation.conditionsDetail = weatherResponse.weather.first?.description ?? ""
                updatedLocation.icon = weatherResponse.weather.first?.icon ?? ""
                updatedLocation.humidity = weatherResponse.main.humidity
                updatedLocation.pressure = weatherResponse.main.pressure
                updatedLocation.windSpeed = weatherResponse.wind.speed
                updatedLocation.sunset = Date(timeIntervalSince1970: TimeInterval(weatherResponse.sys.sunset))
                updatedLocation.sunrise = Date(timeIntervalSince1970: TimeInterval(weatherResponse.sys.sunrise))
                completion(.success(updatedLocation))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Fetches weather data for a specified city name.
    func fetchWeather(forCity cityName: String, completion: @escaping (Result<LocationEntity, Error>) -> Void) {
        guard let url = buildURL(forCityName: cityName) else {
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
                print(weatherResponse)
                let location = LocationEntity(
                    id: UUID(),
                    cityName: weatherResponse.name,
                    latitude: weatherResponse.coord.lat,
                    longitude: weatherResponse.coord.lon,
                    registrationDate: Date(),
                    temperature: weatherResponse.main.temp,
                    conditions: weatherResponse.weather.first?.main ?? "",
                    conditionsDetail: weatherResponse.weather.first?.description ?? "",
                    icon: weatherResponse.weather.first?.icon ?? "",
                    humidity: weatherResponse.main.humidity,
                    windSpeed: weatherResponse.wind.speed, pressure: weatherResponse.main.pressure,
                    sunrise: Date(timeIntervalSince1970: TimeInterval(weatherResponse.sys.sunrise)),
                    sunset: Date(timeIntervalSince1970: TimeInterval(weatherResponse.sys.sunset))
                )
                completion(.success(location))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Constructs the URL for the weather API request by coordinates.
    private func buildURL(for location: LocationEntity) -> URL? {
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        let urlString = "\(baseURL)?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey ?? "")"
        return URL(string: urlString)
    }
    
    // Constructs the URL for the weather API request by city name.
    private func buildURL(forCityName cityName: String) -> URL? {
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        let urlString = "\(baseURL)?q=\(cityName)&appid=\(apiKey ?? "")"
        return URL(string: urlString)
    }
    
    // Defines possible API errors.
    enum APIError: Error {
        case invalidURL
        case noData
    }
}
