//
//  LocationRegistrationCoordinator.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class LocationRegistrationCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let locationRepository: LocationRepositoryInterface
    private let weatherRepository: WeatherRepositoryInterface
    private let notificationService: WeatherNotificationService
    private weak var weatherStatusViewController: WeatherStatusViewController?
    weak var parentCoordinator: Coordinator?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController,
         locationRepository: LocationRepositoryInterface,
         weatherRepository: WeatherRepositoryInterface,
         weatherStatusViewController: WeatherStatusViewController,
         notificationService: WeatherNotificationService) { 
        self.navigationController = navigationController
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
        self.weatherStatusViewController = weatherStatusViewController
        self.notificationService = notificationService
    }
    
    // MARK: - Coordinator Methods
    
    func start() {
        let locationRegistrationViewModel = LocationRegistrationViewModel(
            locationRepository: locationRepository,
            weatherRepository: weatherRepository,
            notificationService: notificationService
        )
        
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
        
        if let parent = parentCoordinator as? WeatherStatusCoordinator {
            parent.didRegisterLocation()
        }
    }
    
    func didFinish() {
        navigationController.dismiss(animated: true, completion: nil)
        
        if let parent = parentCoordinator as? WeatherStatusCoordinator {
            parent.didRegisterLocation()
        }
    }
    
    func showLocationRegistration() {
        start() // This calls start to begin the registration process
    }
}
