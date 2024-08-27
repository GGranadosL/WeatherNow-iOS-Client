//
//  WeatherStatusCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo Granados Lopez on 23/08/24.
//

import UIKit

class WeatherStatusCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let locationRepository: LocationRepositoryInterface
    private let weatherRepository: WeatherRepositoryInterface
    private let notificationService: WeatherNotificationService
    var weatherStatusViewController: WeatherStatusViewController?

    // MARK: - Initialization
    
    init(navigationController: UINavigationController,
         locationRepository: LocationRepositoryInterface,
         weatherRepository: WeatherRepositoryInterface,
         notificationService: WeatherNotificationService) {
        self.navigationController = navigationController
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
        self.notificationService = notificationService
    }
    
    // MARK: - Coordinator Methods
    
    func start() {
        let weatherStatusViewModel = WeatherStatusViewModel(
            weatherRepository: weatherRepository,
            locationRepository: locationRepository,
            notificationService: notificationService  
        )
        let weatherStatusViewController = WeatherStatusViewController(viewModel: weatherStatusViewModel, notificationService: notificationService)
        weatherStatusViewController.coordinator = self
        self.weatherStatusViewController = weatherStatusViewController
        navigationController.pushViewController(weatherStatusViewController, animated: true)
    }
    
    func showLocationRegistration() {
        guard let weatherStatusViewController = navigationController.topViewController as? WeatherStatusViewController else {
            fatalError("WeatherStatusViewController is not the top view controller")
        }
        
        let locationRegistrationCoordinator = LocationRegistrationCoordinator(
            navigationController: navigationController,
            locationRepository: locationRepository,
            weatherRepository: weatherRepository,
            weatherStatusViewController: weatherStatusViewController, 
            notificationService: notificationService
        )
        locationRegistrationCoordinator.parentCoordinator = self
        addChildCoordinator(locationRegistrationCoordinator)
        locationRegistrationCoordinator.start()
    }

    func didRegisterLocation() {
        weatherStatusViewController?.reloadWeatherData()
    }

    func childDidFinish(_ child: Coordinator?) {
        guard let child = child else { return }
        childCoordinators.removeAll { $0 === child }
    }
}
