//
//  LocationEntity.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

/// Represents a location entity in the data layer.
struct LocationEntity: Codable {
    let id: UUID
    var cityName: String
    let latitude: Double
    let longitude: Double
    let registrationDate: Date
    var temperature: Double
    var conditions: String
    var conditionsDetail: String
    var icon: String
    var humidity: Int  
    var windSpeed: Double
    var pressure: Int
    var sunrise: Date
    var sunset: Date
    
    /// Default initializer for creating location instances.
    /// - Parameters:
    ///   - id: Unique identifier for the location.
    ///   - cityName: Name of the city.
    ///   - latitude: Latitude coordinate of the location.
    ///   - longitude: Longitude coordinate of the location.
    ///   - registrationDate: Date when the location was registered.
    ///   - temperature: Temperature at the location.
    ///   - conditions: Weather conditions at the location.
    ///   - icon: Icon representing the weather conditions.
    ///   - humidity: Percentage of humidity at the location.
    ///   - windSpeed: Speed of wind at the location in m/s.
    ///   - pressure: Atmospheric pressure at the location in hPa.
    ///   - sunrise: Time of sunrise at the location.
    ///   - sunset: Time of sunset at the location.
    init(
        id: UUID = UUID(),
        cityName: String,
        latitude: Double,
        longitude: Double,
        registrationDate: Date = Date(),
        temperature: Double = 0,
        conditions: String = "",
        conditionsDetail: String = "",
        icon: String = "",
        humidity: Int = 0,
        windSpeed: Double = 0.0,
        pressure: Int = 0,
        sunrise: Date = Date(),
        sunset: Date = Date()
    ) {
        self.id = id
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.registrationDate = registrationDate
        self.temperature = temperature
        self.conditions = conditions
        self.conditionsDetail = conditionsDetail
        self.icon = icon
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    /// Converts `LocationEntity` to `Location` domain model.
    func toDomainLocation() -> Location {
        return Location(
            id: id.uuidString,
            cityName: cityName,
            latitude: String(latitude),
            longitude: String(longitude),
            registrationDate: ISO8601DateFormatter().string(from: registrationDate),
            temperature: String(format: "%.1f°C", temperature - 273.15), // Convert from Kelvin to Celsius
            conditions: conditions,
            conditionsDetail: conditionsDetail,
            icon: icon,
            humidity: "\(humidity)%",
            windSpeed: "\(windSpeed) m/s",
            pressure: "\(pressure) hPa",
            sunrise: ISO8601DateFormatter().string(from: sunrise),
            sunset: ISO8601DateFormatter().string(from: sunset)
        )
    }
    
    /// Example of a default location to be used when the user's location is not available.
    static let defaultLocation = LocationEntity(
        cityName: "Default City",
        latitude: 0.0,
        longitude: 0.0,
        temperature: 295.2,
        conditions: "Clouds",
        conditionsDetail: "broken clouds",
        icon: "04n",
        humidity: 75,
        windSpeed: 5.0,
        pressure: 1013,
        sunrise: Date(), // You can set specific times here
        sunset: Date() // You can set specific times here
    )
}




