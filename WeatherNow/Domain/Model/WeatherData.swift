//
//  WeatherData.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [WeatherCondition]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct WeatherCondition: Codable {
        let description: String
        let icon: String
    }
    
    var temperature: String {
        return String(format: "%.1f°C", main.temp - 273.15) // Convert from Kelvin to Celsius
    }
    
    var description: String {
        return weather.first?.description ?? ""
    }
    
    var icon: String {
        return weather.first?.icon ?? ""
    }
}

