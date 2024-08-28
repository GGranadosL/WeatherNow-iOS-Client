//
//  NotificationService.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//
// Handles the notification permissions and scheduling of notifications
import UserNotifications

class NotificationService {

    // Requests permission to show notifications
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    // Schedules a notification with a given content and trigger
    func scheduleNotification(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
}
