//
//  LocationRegistrationCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class LocationRegistrationCoordinator: Coordinator {
    func showLocationRegistration() {
        //
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let locationRepository: LocationRepositoryInterface
    
    init(navigationController: UINavigationController,
         locationRepository: LocationRepositoryInterface) {
        self.navigationController = navigationController
        self.locationRepository = locationRepository
    }
    
    func start() {
        let locationRegistrationViewModel = LocationRegistrationViewModel(locationRepository: locationRepository)
        let locationRegistrationViewController = LocationRegistrationViewController(viewModel: locationRegistrationViewModel)
        locationRegistrationViewController.coordinator = self
        navigationController.present(locationRegistrationViewController, animated: true, completion: nil)
    }
    
    func didFinish() {
        navigationController.dismiss(animated: true, completion: nil)
        // You might want to notify the parent coordinator about completion here
    }
}



