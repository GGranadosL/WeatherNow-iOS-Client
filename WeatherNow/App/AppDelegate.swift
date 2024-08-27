//
//  AppDelegate.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var mainCoordinator: MainCoordinator?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Save API key if not already saved
        if KeychainHelper.shared.getAPIKey() == nil {
            let apiKey = "a5f8704cc91234ed73362e270c5eb343"
            KeychainHelper.shared.saveAPIKey(apiKey)
        }
        // Request notification permissions at app launch
        let notificationService = NotificationService()
        notificationService.requestNotificationPermission()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        requestNotificationAuthorization()
        configureNotificationSettings()
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        mainCoordinator?.performBackgroundFetch(completionHandler: completionHandler)
    }
    
    
    // Handle notification presentation while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }
    
    // Handle notification interactions
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "VIEW_ACTION" {
            // Handle the view action
        } else if response.actionIdentifier == "IGNORE_ACTION" {
            // Handle the ignore action
        }
        
        completionHandler()
    }
    
    func configureNotificationSettings() {
        let center = UNUserNotificationCenter.current()
        
        // Define notification actions
        let viewAction = UNNotificationAction(identifier: "VIEW_ACTION",
                                              title: "View",
                                              options: [.foreground])
        
        let ignoreAction = UNNotificationAction(identifier: "IGNORE_ACTION",
                                                title: "Ignore",
                                                options: [])
        
        // Define a notification category
        let weatherCategory = UNNotificationCategory(identifier: "WEATHER_CATEGORY",
                                                     actions: [viewAction, ignoreAction],
                                                     intentIdentifiers: [],
                                                     options: [])
        
        // Register the notification category
        center.setNotificationCategories([weatherCategory])
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            
            // Enable or disable features based on the authorization.
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

