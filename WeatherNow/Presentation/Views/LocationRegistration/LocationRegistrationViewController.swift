//
//  LocationRegistrationViewController.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

protocol LocationRegistrationViewControllerDelegate: AnyObject {
    func didRegisterLocation()
}

class LocationRegistrationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let viewModel: LocationRegistrationViewModel
    weak var delegate: LocationRegistrationViewControllerDelegate?
    
    // Use the separated view
    private let registrationView = LocationRegistrationView()
    private let uuid: UUID
    weak var coordinator: LocationRegistrationCoordinator?
    
    // MARK: - Initialization
    
    init(viewModel: LocationRegistrationViewModel) {
        self.viewModel = viewModel
        self.uuid = UUID()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: - Setup
    
    private func setupViewController() {
        title = "Register Location"
        registrationView.configure(id: uuid.uuidString)
        registrationView.cityNameTextField.delegate = self
        registrationView.latitudeTextField.delegate = self
        registrationView.longitudeTextField.delegate = self
        
        registrationView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // Handles the save button tap event
    @objc private func saveButtonTapped() {
        // Check if both latitude and longitude are filled
        if let latitudeString = registrationView.latitudeTextField.text,
           let longitudeString = registrationView.longitudeTextField.text,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
           
            // Ensure latitude and longitude are within valid ranges
            guard (latitude >= -90 && latitude <= 90) && (longitude >= -180 && longitude <= 180) else {
                showAlert(title: "Error", message: "Invalid coordinates. Please enter valid latitude and longitude values.")
                return
            }

            // Perform API call by coordinates
            let location = LocationEntity(id: uuid, cityName: "", latitude: latitude, longitude: longitude, registrationDate: Date())
            viewModel.registerLocation(location: location)

        } else if let cityName = registrationView.cityNameTextField.text, !cityName.isEmpty {
            // Perform API call by city name
            viewModel.registerLocation(cityName: cityName)
        } else {
            // Show an alert for missing input
            showAlert(title: "Error", message: "Please enter either a city name or coordinates.")
            return
        }

        // Set the onLocationRegistered callback to stop the indicator and dismiss the view
        viewModel.onLocationRegistered = { [weak self] in
            DispatchQueue.main.async {
                self?.coordinator?.didRegisterLocation()
                self?.delegate?.didRegisterLocation()
                self?.dismiss(animated: true, completion: nil)
            }
        }

        // Set the onLocationFail callback to stop the indicator and show an error alert
        viewModel.onLocationFail = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: "No results found. Please try again.")
            }
        }
    }
    
    // Helper function to show alerts
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
