//
//  LocationRegistrationView.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class LocationRegistrationView: UIView {
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register New Location"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "You can either enter a city name or latitude and longitude."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    let idValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Text field for latitude
    let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Latitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numbersAndPunctuation
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Text field for longitude
    let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Longitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numbersAndPunctuation
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Save button
    let saveButton: UIButton = {
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
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        backgroundColor = .white
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(instructionLabel)
        addSubview(idLabel)
        addSubview(idValueLabel)
        addSubview(cityNameTextField)
        addSubview(latitudeTextField)
        addSubview(longitudeTextField)
        addSubview(saveButton)
        addSubview(activityIndicator)
        
        // Setup layout using Auto Layout
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idValueLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameTextField.translatesAutoresizingMaskIntoConstraints = false
        latitudeTextField.translatesAutoresizingMaskIntoConstraints = false
        longitudeTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            instructionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            idLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            idLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            idValueLabel.centerYAnchor.constraint(equalTo: idLabel.centerYAnchor),
            idValueLabel.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 10),
            
            cityNameTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
            cityNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityNameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            latitudeTextField.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 20),
            latitudeTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            latitudeTextField.widthAnchor.constraint(equalToConstant: 250),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 40),
            longitudeTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            longitudeTextField.widthAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(id: String) {
        idValueLabel.text = id
    }
}

