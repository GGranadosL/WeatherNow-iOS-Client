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
    
    // Page title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register New Location"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Instruction label
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "You can either enter a city name or latitude and longitude."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Text field for latitude
    private let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Latitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numbersAndPunctuation
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Text field for longitude
    private let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Longitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numbersAndPunctuation
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Text field for city name
    private let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Save button
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Location", for: .normal)
        button.backgroundColor = UIColor(red: 238/255, green: 80/255, blue: 50/255, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Activity Indicator to show while processing the request
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    weak var coordinator: LocationRegistrationCoordinator?
    
    // MARK: - Initialization
    
    init(viewModel: LocationRegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup
    
    // Configures the view and its components
    private func setupView() {
        view.backgroundColor = .white
        title = "Register Location"
        
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeTextField)
        view.addSubview(cityNameTextField)
        view.addSubview(saveButton)
        view.addSubview(activityIndicator) // Add the activity indicator to the view
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cityNameTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            cityNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityNameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            latitudeTextField.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 20),
            latitudeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            latitudeTextField.widthAnchor.constraint(equalToConstant: 250),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 20),
            longitudeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            longitudeTextField.widthAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // Handles the save button tap event
    @objc private func saveButtonTapped() {
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        // Check if both latitude and longitude are filled
        if let latitudeString = latitudeTextField.text,
           let longitudeString = longitudeTextField.text,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
            
            // Perform API call by coordinates
            let location = LocationEntity(id: UUID(), cityName: "", latitude: latitude, longitude: longitude, registrationDate: Date())
            viewModel.registerLocation(location: location)
            
        } else if let cityName = cityNameTextField.text, !cityName.isEmpty {
            // Perform API call by city name
            viewModel.registerLocation(cityName: cityName)
        } else {
            // Show an alert for missing input
            activityIndicator.stopAnimating()
            showAlert(title: "Error", message: "Please enter either a city name or coordinates.")
            return
        }
        
        // Set the onLocationRegistered callback to stop the indicator and dismiss the view
        viewModel.onLocationRegistered = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.coordinator?.didRegisterLocation()
                self?.delegate?.didRegisterLocation()
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        // Set the onLocationFail callback to stop the indicator and show an error alert
        viewModel.onLocationFail = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
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
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only numbers, one decimal point, and negative sign
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.-")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
