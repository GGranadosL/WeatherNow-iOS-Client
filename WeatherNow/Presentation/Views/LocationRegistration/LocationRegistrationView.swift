//
//  LocationRegistrationView.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import UIKit

class LocationRegistrationView: UIView {
    
    // MARK: - UI Elements
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let idValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter City Name"
        textField.font = .systemFont(ofSize: 18)
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.setUnderline()
        return textField
    }()
    
    let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Latitude"
        textField.font = .systemFont(ofSize: 18)
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.setUnderline()
        return textField
    }()
    
    let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Longitude"
        textField.font = .systemFont(ofSize: 18)
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.setUnderline()
        return textField
    }()
    
    private let registrationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration Date:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let registrationDateValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Location", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        return button
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
        addSubview(idLabel)
        addSubview(idValueLabel)
        addSubview(cityNameTextField)
        addSubview(latitudeTextField)
        addSubview(longitudeTextField)
        addSubview(registrationDateLabel)
        addSubview(registrationDateValueLabel)
        addSubview(saveButton)
        
        // Setup layout using Auto Layout
        setupConstraints()
    }
    
    private func setupConstraints() {
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idValueLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameTextField.translatesAutoresizingMaskIntoConstraints = false
        latitudeTextField.translatesAutoresizingMaskIntoConstraints = false
        longitudeTextField.translatesAutoresizingMaskIntoConstraints = false
        registrationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        registrationDateValueLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            idLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            idValueLabel.centerYAnchor.constraint(equalTo: idLabel.centerYAnchor),
            idValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            idValueLabel.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 10),
            
            cityNameTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 40),
            cityNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cityNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            latitudeTextField.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 30),
            latitudeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            latitudeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 30),
            longitudeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            longitudeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            registrationDateLabel.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 40),
            registrationDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            registrationDateValueLabel.centerYAnchor.constraint(equalTo: registrationDateLabel.centerYAnchor),
            registrationDateValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            registrationDateValueLabel.leadingAnchor.constraint(equalTo: registrationDateLabel.trailingAnchor, constant: 10),
            
            saveButton.topAnchor.constraint(equalTo: registrationDateLabel.bottomAnchor, constant: 60),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(id: String, registrationDate: String) {
        idValueLabel.text = id
        registrationDateValueLabel.text = registrationDate
    }
}

// MARK: - Extensions

private extension UITextField {
    func setUnderline() {
        let underline = CALayer()
        underline.backgroundColor = UIColor.lightGray.cgColor
        underline.frame = CGRect(x: 0, y: self.frame.height + 10, width: self.frame.width, height: 1)
        self.borderStyle = .none
        self.layer.addSublayer(underline)
    }
}
