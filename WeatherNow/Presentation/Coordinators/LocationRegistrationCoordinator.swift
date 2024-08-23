//
//  LocationRegistrationCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class LocationRegistrationCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let locationRepository: LocationRepositoryInterface
    
    init(navigationController: UINavigationController, locationRepository: LocationRepositoryInterface) {
        self.navigationController = navigationController
        self.locationRepository = locationRepository
    }
    
    func start() {
        let viewModel = LocationRegistrationViewModel(locationRepository: locationRepository)
        let viewController = LocationRegistrationViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didRegisterLocation() {
        navigationController.popViewController(animated: true)
    }
}

