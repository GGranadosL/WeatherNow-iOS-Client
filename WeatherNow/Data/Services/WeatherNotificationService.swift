//
//  WeatherNotificationService.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//
// Monitors significant weather changes and triggers notifications
import Foundation
import UserNotifications

class WeatherNotificationService {

    private let notificationService: NotificationService
    private let userDefaults = UserDefaults.standard
    private let previousWeatherKey = "previousWeatherData"

    // Initializes the service with a dependency on NotificationService
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    // Checks for significant weather changes and triggers a notification
    func checkForSignificantWeatherChange(previousWeather: LocationEntity, currentWeather: LocationEntity) {
        if hasSignificantWeatherChange(from: previousWeather, to: currentWeather) {
            scheduleWeatherChangeNotification(for: currentWeather)
            saveWeatherData(currentWeather) // Save the current weather as the previous one after sending notification
        }
    }

    // Determines if there has been a significant change in weather
    private func hasSignificantWeatherChange(from oldWeather: LocationEntity, to newWeather: LocationEntity) -> Bool {
        return abs(oldWeather.temperature - newWeather.temperature) > 2.0
    }

    // Schedules a notification for a significant weather change
    private func scheduleWeatherChangeNotification(for weather: LocationEntity) {
        let content = UNMutableNotificationContent()
        content.title = "Weather Alert"
        content.body = "Significant weather change detected: \(weather.cityName)"
        content.sound = .default

        // Trigger the notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        notificationService.scheduleNotification(content: content, trigger: trigger)
    }

    // Loads the previous weather data from persistent storage
    func loadPreviousWeatherData() -> [String: LocationEntity] {
        if let data = userDefaults.data(forKey: previousWeatherKey),
           let weatherData = try? JSONDecoder().decode([String: LocationEntity].self, from: data) {
            return weatherData
        }
        return [:]
    }

    // Saves the weather data to persistent storage
    private func saveWeatherData(_ weather: LocationEntity) {
        var weatherData = loadPreviousWeatherData()
        weatherData[weather.cityName] = weather
        
        if let data = try? JSONEncoder().encode(weatherData) {
            userDefaults.set(data, forKey: previousWeatherKey)
        }
    }
}

