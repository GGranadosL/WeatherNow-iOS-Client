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
    var weatherStatusViewController: WeatherStatusViewController?
    
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
        let weatherStatusViewModel = WeatherStatusViewModel(weatherRepository: weatherRepository, locationRepository: locationRepository)
        let weatherStatusViewController = WeatherStatusViewController(viewModel: weatherStatusViewModel)
        weatherStatusViewController.coordinator = self
        self.weatherStatusViewController = weatherStatusViewController // Guardar la referencia
        navigationController.setViewControllers([weatherStatusViewController], animated: false)
    }
    
    func showLocationRegistration() {
        guard let weatherStatusViewController = weatherStatusViewController else {
               print("WeatherStatusViewController is nil")
               return
        }
        
        let locationRegistrationCoordinator = LocationRegistrationCoordinator(
            navigationController: navigationController,
            locationRepository: locationRepository,
            weatherRepository: weatherRepository,
            weatherStatusViewController: weatherStatusViewController
        )
        
        addChildCoordinator(locationRegistrationCoordinator)
        locationRegistrationCoordinator.start()
    }
    
    func didRegisterLocation() {
        weatherStatusViewController?.viewModel.loadWeatherData()
        weatherStatusViewController?.tableView.reloadData()
    }

}
