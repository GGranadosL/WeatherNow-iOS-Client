//
//  WeatherRepositoryInterface.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

protocol WeatherRepositoryInterface {
    // Fetch Weather Data
    func fetchWeather(forLocation location: Location, completion: @escaping (Result<Weather, Error>) -> Void)
}

