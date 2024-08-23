//
//  MainCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class MainCoordinator: Coordinator {

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
        let weatherStatusCoordinator = WeatherStatusCoordinator(
            navigationController: navigationController,
            weatherRepository: weatherRepository,
            locationRepository: locationRepository
        )
        childCoordinators.append(weatherStatusCoordinator)
        weatherStatusCoordinator.start()
    }
}




