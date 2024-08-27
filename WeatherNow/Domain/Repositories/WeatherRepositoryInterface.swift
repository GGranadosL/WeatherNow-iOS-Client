//
//  WeatherRepositoryInterface.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

/// Protocol defining the interface for fetching weather data.
protocol WeatherRepositoryInterface {
    /// Fetches weather data for a given location.
    /// - Parameters:
    ///   - location: The location for which to fetch weather data.
    ///   - completion: A closure that gets called with the result of the request.
    func fetchWeather(forLocation location: LocationEntity, completion: @escaping (Result<LocationEntity, Error>) -> Void)
    
    /// Fetches weather data for a given location.
    /// - Parameters:
    ///   - cityName: The name of city to fetch weather data.
    ///   - completion: A closure that gets called with the result of the request.
    func fetchWeather(forCity cityName: String, completion: @escaping (Result<LocationEntity, Error>) -> Void)
}


