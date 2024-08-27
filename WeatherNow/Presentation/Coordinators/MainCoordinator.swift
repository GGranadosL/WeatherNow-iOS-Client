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
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController,
         locationRepository: LocationRepositoryInterface,
         weatherRepository: WeatherRepositoryInterface) {
        self.navigationController = navigationController
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
    }
    
    // MARK: - Coordinator
    
    func start() {
        showWeatherStatus()
    }
    
    private func showWeatherStatus() {
        let weatherStatusViewModel = WeatherStatusViewModel(weatherRepository: weatherRepository)
        let weatherStatusViewController = WeatherStatusViewController(viewModel: weatherStatusViewModel)
        weatherStatusViewController.coordinator = self
        navigationController.setViewControllers([weatherStatusViewController], animated: false)
    }
    
    func showLocationRegistration() {
        let locationRegistrationCoordinator = LocationRegistrationCoordinator(navigationController: navigationController, locationRepository: locationRepository)
        childCoordinators.append(locationRegistrationCoordinator)
        locationRegistrationCoordinator.start()
    }
}







