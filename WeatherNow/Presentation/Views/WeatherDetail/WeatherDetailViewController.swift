//
//  WeatherDetailViewController.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    // MARK: - Properties
    
    private let location: Location

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunriseSunsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let additionalDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        configureViewWithLocationData()
    }
    
    // MARK: - Setup Navigation Bar
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white // Make the back button white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(weatherIconImageView)
        view.addSubview(weatherDescriptionLabel)
        view.addSubview(humidityLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(pressureLabel)
        view.addSubview(sunriseSunsetLabel)
        view.addSubview(additionalDetailsLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherIconImageView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 50),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            weatherDescriptionLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 10),
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            humidityLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 20),
            humidityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            windSpeedLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 10),
            windSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pressureLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 10),
            pressureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sunriseSunsetLabel.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor, constant: 20),
            sunriseSunsetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            additionalDetailsLabel.topAnchor.constraint(equalTo: sunriseSunsetLabel.bottomAnchor, constant: 20),
            additionalDetailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            additionalDetailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Adding the gradient background
        applyGradientBackground()
    }

    private func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Configure View with Data
    
    private func configureViewWithLocationData() {
        
        cityNameLabel.text = location.cityName
        temperatureLabel.text = location.temperature
        weatherDescriptionLabel.text = location.conditions.capitalized
        humidityLabel.text = "Humidity: \(location.humidity)"
        windSpeedLabel.text = "Wind Speed: \(location.windSpeed)"
        pressureLabel.text = "Pressure: \(location.pressure)"
        
        // Configure weather icon
        if let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(location.icon)@2x.png") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: iconUrl) {
                    DispatchQueue.main.async {
                        self.weatherIconImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        // Format sunrise and sunset times
        let formattedSunrise = location.sunrise.toFormattedTime() ?? "N/A"
        let formattedSunset = location.sunset.toFormattedTime() ?? "N/A"
        
        sunriseSunsetLabel.text = "Sunrise: \(formattedSunrise) | Sunset: \(formattedSunset)"
        
        // Adding additional weather details
        additionalDetailsLabel.text = "Weather detail: \(location.conditionsDetail) "
    }
}

// Extension to convert and format dates
extension String {
    
    /// Converts an ISO8601 string to a `Date` object.
    func toDate() -> Date? {
        let isoDateFormatter = ISO8601DateFormatter()
        return isoDateFormatter.date(from: self)
    }
    
    /// Formats an ISO8601 string to a readable time format.
    /// - Returns: A string with the formatted time, or `nil` if the conversion fails.
    func toFormattedTime() -> String? {
        guard let date = self.toDate() else { return nil }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "h:mm a"
        return displayFormatter.string(from: date)
    }
}
