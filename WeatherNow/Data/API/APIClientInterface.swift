//
//  APIClientInterface.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import Foundation

/// Protocol defining the interface for the API client responsible for fetching weather data.
protocol APIClientInterface {
    
    /// Fetches weather data for the specified latitude and longitude.
    /// - Parameters:
    ///   - latitude: The latitude of the location.
    ///   - longitude: The longitude of the location.
    ///   - completion: A completion handler that returns a `Result` with either a `WeatherResponse` or an `Error`.
    func fetchWeather(forLocation location: LocationEntity, completion: @escaping (Result<LocationEntity, Error>) -> Void)
    
    /// Fetches weather data for the specified city name.
    /// - Parameters:
    ///   - cityName: The name of the city.
    ///   - completion: A completion handler that returns a `Result` with either a `WeatherResponse` or an `Error`.
    func fetchWeather(forCity cityName: String, completion: @escaping (Result<LocationEntity, Error>) -> Void) 
}

