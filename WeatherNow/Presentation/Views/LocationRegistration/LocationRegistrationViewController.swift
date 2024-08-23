//
//  LocationRegistrationViewController.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class LocationRegistrationViewController: UIViewController {
    
    private let locationRegistrationView = LocationRegistrationView()
    private let viewModel: LocationRegistrationViewModel
    
    // MARK: - Initialization
    
    init(viewModel: LocationRegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = locationRegistrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindViewModel()
    }
    
    // MARK: - Configure View
    
    private func configureView() {
        locationRegistrationView.configure(id: viewModel.generateNewId(), registrationDate: viewModel.currentDate())
        locationRegistrationView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        viewModel.onSaveSuccess = { [weak self] in
            self?.showSuccessAlert()
        }
        
        viewModel.onSaveError = { [weak self] error in
            self?.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        guard let cityName = locationRegistrationView.cityNameTextField.text,
              let latitude = locationRegistrationView.latitudeTextField.text,
              let longitude = locationRegistrationView.longitudeTextField.text else {
            showErrorAlert(message: "Please fill in all fields.")
            return
        }
        
        viewModel.saveLocation(cityName: cityName, latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Alerts
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Location saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
