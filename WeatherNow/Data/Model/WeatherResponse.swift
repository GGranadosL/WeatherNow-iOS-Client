//
//  WeatherData.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

// Representa la respuesta cruda de la API del clima.
struct WeatherResponse: Codable {
    let main: Main
    let weather: [WeatherCondition]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct WeatherCondition: Codable {
        let description: String
        let icon: String
    }
}


