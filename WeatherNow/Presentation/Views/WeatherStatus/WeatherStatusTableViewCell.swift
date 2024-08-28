//
//  WeatherStatusTableViewCell.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import UIKit

class WeatherStatusTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupCardStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(weatherIconImageView)
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: weatherIconImageView.leadingAnchor, constant: -8),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 4),
            temperatureLabel.trailingAnchor.constraint(lessThanOrEqualTo: weatherIconImageView.leadingAnchor, constant: -8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: weatherIconImageView.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            weatherIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupCardStyle() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.cornerRadius = 8
    }
    
    // MARK: - Configuration
    
    func configure(with location: Location) {
        cityNameLabel.text = location.cityName
        temperatureLabel.text = location.temperature
        descriptionLabel.text = location.conditions
        loadWeatherIcon(for: location.icon)
    }
    
    private func loadWeatherIcon(for iconName: String) {
        let urlString = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        guard let url = URL(string: urlString) else {
            weatherIconImageView.image = UIImage(systemName: "cloud.sun.fill") // Fallback placeholder
            return
        }
        
        // Perform image loading asynchronously
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.weatherIconImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.weatherIconImageView.image = UIImage(systemName: "cloud.sun.fill") // Fallback placeholder
                }
            }
        }.resume()
    }
}


