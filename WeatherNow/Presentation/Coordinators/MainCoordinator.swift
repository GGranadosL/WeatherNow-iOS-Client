//
//  MainCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let locationRepository: LocationRepositoryInterface
    private let weatherRepository: WeatherRepositoryInterface
    private let notificationService: WeatherNotificationService
    private let calendarService: CalendarService
    var weatherStatusViewModel: WeatherStatusViewModel?
    var weatherStatusViewController: WeatherStatusViewController?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController,
         locationRepository: LocationRepositoryInterface,
         weatherRepository: WeatherRepositoryInterface,
         notificationService: WeatherNotificationService,
         calendarService: CalendarService) {
        self.navigationController = navigationController
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
        self.notificationService = notificationService
        self.calendarService = calendarService
    }
    
    // MARK: - Coordinator
    
    func start() {
        showWeatherStatus()
    }
    
    private func showWeatherStatus() {
        let weatherStatusViewModel = WeatherStatusViewModel(calendarService: calendarService, weatherRepository: weatherRepository, locationRepository: locationRepository, notificationService: notificationService)
        let weatherStatusViewController = WeatherStatusViewController(viewModel: weatherStatusViewModel, notificationService: notificationService, calendarService: calendarService)
        weatherStatusViewController.coordinator = self
        self.weatherStatusViewController = weatherStatusViewController // Save the reference
        navigationController.setViewControllers([weatherStatusViewController], animated: false)
    }
    
    func showLocationRegistration() {
        guard let weatherStatusViewController = self.weatherStatusViewController else {
            fatalError("WeatherStatusViewController is not set or is nil")
        }
        
        let locationRegistrationCoordinator = LocationRegistrationCoordinator(
            navigationController: navigationController,
            locationRepository: locationRepository,
            weatherRepository: weatherRepository,
            weatherStatusViewController: weatherStatusViewController, // Unwrapped instance
            notificationService: notificationService // Pass the notification service here
        )
        locationRegistrationCoordinator.parentCoordinator = self
        addChildCoordinator(locationRegistrationCoordinator)
        locationRegistrationCoordinator.start()
    }

    
    func didRegisterLocation() {
        weatherStatusViewController?.viewModel.loadWeatherData()
        weatherStatusViewController?.tableView.reloadData()
    }
    
    func performBackgroundFetch(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        weatherStatusViewModel?.fetchWeatherInBackground { success in
            completionHandler(success ? .newData : .noData)
        }
    }

}
