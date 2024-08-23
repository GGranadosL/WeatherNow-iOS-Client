//
//  WeatherRepository.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

class WeatherRepository: WeatherRepositoryInterface {
    func fetchWeather(forLocation location: Location, completion: @escaping (Result<Weather, Error>) -> Void) {
        // Realiza una solicitud a la API para obtener datos meteorológicos para la ubicación
        // Luego llama a completion con el resultado
    }
}

