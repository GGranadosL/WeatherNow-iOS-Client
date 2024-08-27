//
//  LocationRegistrationCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class LocationRegistrationCoordinator: Coordinator {
    func showLocationRegistration() {}
    
    
    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let locationRepository: LocationRepositoryInterface
    private let weatherRepository: WeatherRepositoryInterface
    private weak var weatherStatusViewController: WeatherStatusViewController?
    weak var parentCoordinator: Coordinator?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController,
         locationRepository: LocationRepositoryInterface,
         weatherRepository: WeatherRepositoryInterface,
         weatherStatusViewController: WeatherStatusViewController) {
        self.navigationController = navigationController
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
        self.weatherStatusViewController = weatherStatusViewController
    }
    
    // MARK: - Coordinator Methods
    
    func start() {
        let locationRegistrationViewModel = LocationRegistrationViewModel(locationRepository: locationRepository, weatherRepository: weatherRepository)
        
        locationRegistrationViewModel.onLocationRegistered = { [weak self] in
            self?.didRegisterLocation()
        }
        
        let locationRegistrationViewController = LocationRegistrationViewController(viewModel: locationRegistrationViewModel)
        locationRegistrationViewController.coordinator = self
        locationRegistrationViewController.delegate = weatherStatusViewController
        navigationController.present(locationRegistrationViewController, animated: true, completion: nil)
    }
    
    func didRegisterLocation() {
        weatherStatusViewController?.viewModel.loadWeatherData()
        weatherStatusViewController?.tableView.reloadData()
        
        navigationController.dismiss(animated: true, completion: nil)
        
        // Cast parentCoordinator to WeatherStatusCoordinator and call didRegisterLocation
        if let parent = parentCoordinator as? WeatherStatusCoordinator {
            parent.didRegisterLocation()
        } else {
            // Handle other types of coordinators if necessary
        }
    }
    
    func didFinish() {
        navigationController.dismiss(animated: true, completion: nil)
        
        // Cast parentCoordinator to WeatherStatusCoordinator and call didRegisterLocation
        if let parent = parentCoordinator as? WeatherStatusCoordinator {
            parent.didRegisterLocation()
        } else {
            // Handle other types of coordinators if necessary
        }
    }
}



