//
//  WeatherStatusCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import UIKit

class WeatherStatusCoordinator: Coordinator {

    // MARK: - Properties

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let weatherRepository: WeatherRepositoryInterface
    private let locationRepository: LocationRepositoryInterface

    // MARK: - Initialization

    init(navigationController: UINavigationController,
         weatherRepository: WeatherRepositoryInterface,
         locationRepository: LocationRepositoryInterface) {
        self.navigationController = navigationController
        self.weatherRepository = weatherRepository
        self.locationRepository = locationRepository
    }

    // MARK: - Coordinator

    func start() {
        let viewModel = WeatherStatusViewModel(
            locations: locationRepository.getLocations(),
            weatherData: [],
            weatherRepository: weatherRepository,
            locationRepository: locationRepository
        )
        let viewController = WeatherStatusViewController(viewModel: viewModel)
        viewController.title = "Weather Status"
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showLocationRegistration() {
        let locationRegistrationCoordinator = LocationRegistrationCoordinator(
            navigationController: navigationController,
            locationRepository: locationRepository
        )
        childCoordinators.append(locationRegistrationCoordinator)
        locationRegistrationCoordinator.start()
    }
}

