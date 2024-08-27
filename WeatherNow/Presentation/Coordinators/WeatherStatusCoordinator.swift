//
//  WeatherStatusCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import UIKit

class WeatherStatusCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let locationRepository: LocationRepositoryInterface
    private let weatherRepository: WeatherRepositoryInterface
    var weatherStatusViewController: WeatherStatusViewController?

    init(navigationController: UINavigationController,
         locationRepository: LocationRepositoryInterface,
         weatherRepository: WeatherRepositoryInterface) {
        self.navigationController = navigationController
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
    }
    
    func start() {
        let weatherStatusViewModel = WeatherStatusViewModel(weatherRepository: weatherRepository, locationRepository: locationRepository)
        let weatherStatusViewController = WeatherStatusViewController(viewModel: weatherStatusViewModel)
        weatherStatusViewController.coordinator = self
        self.weatherStatusViewController = weatherStatusViewController // Guardar referencia para actualizar la vista después
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
            weatherStatusViewController: weatherStatusViewController // Asegúrate de pasar la instancia desempaquetada
        )
        locationRegistrationCoordinator.parentCoordinator = self
        addChildCoordinator(locationRegistrationCoordinator)
        locationRegistrationCoordinator.start()
    }

    func didRegisterLocation() {
        weatherStatusViewController?.reloadWeatherData()
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}



