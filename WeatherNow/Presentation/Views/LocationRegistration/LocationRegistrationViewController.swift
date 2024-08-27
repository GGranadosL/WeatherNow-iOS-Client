//
//  LocationRegistrationViewController.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit
import CoreLocation

class LocationRegistrationViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: LocationRegistrationViewModel
    private let locationManager = CLLocationManager()
    
    private let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Location", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var location: CLLocation?
    weak var coordinator: LocationRegistrationCoordinator?
    
    // MARK: - Initialization

    init(viewModel: LocationRegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        locationManager.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocationManager()
        bindViewModel()
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .white
        title = "Register Location"
        
        view.addSubview(cityNameTextField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            cityNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            cityNameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    private func bindViewModel() {
        // Bind to view model properties if needed
    }

    @objc private func saveButtonTapped() {
        guard let cityName = cityNameTextField.text, !cityName.isEmpty else {
            // Show an alert or handle error
            return
        }

        let id = UUID().uuidString
        let registrationDate = Date()

        // Convert CLLocationDegrees to String
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        let location = LocationEntity(cityName: cityName, latitude: latitude ?? 0, longitude: longitude ?? 0)
        
        viewModel.registerLocation(location: location)
        
        // Optionally, dismiss or navigate back
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationRegistrationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            location = currentLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location error
    }
}
