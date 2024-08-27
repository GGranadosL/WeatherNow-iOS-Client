//
//  WeatherStatusViewController.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import UIKit
import CoreLocation

class WeatherStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, LocationRegistrationViewControllerDelegate {
    
    // MARK: - Properties
    
    let viewModel: WeatherStatusViewModel
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let refreshControl = UIRefreshControl()
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Location", for: .normal)
        button.backgroundColor = UIColor(red: 238/255, green: 80/255, blue: 50/255, alpha: 1.0)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    private let locationManager = CLLocationManager()
    weak var coordinator: Coordinator?

    // MARK: - Initialization
    
    init(viewModel: WeatherStatusViewModel) {
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
        bindViewModel()
        activityIndicator.startAnimating()
        requestLocationPermission()
        setupNavigationBarLogo()
        viewModel.loadWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadWeatherData()
        view.backgroundColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    // MARK: - Setup
    
    // Sets up the view components and layout
    private func setupView() {
        view.backgroundColor = .white
        title = "Weather Status"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherStatusTableViewCell.self, forCellReuseIdentifier: "WeatherStatusCell")
        
        // Add refresh control for pull-to-refresh
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        view.addSubview(tableView)
        view.addSubview(registerButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    func reloadWeatherData() {
        viewModel.loadWeatherData()
        tableView.reloadData()
        refreshControl.endRefreshing() // End refreshing animation
    }
    
    func didRegisterLocation() {
        reloadWeatherData()
    }
    
    private func setupNavigationBarLogo() {
        let logo = UIImage(named: "weatherNowInc")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    // Refresh data when pulling down the table view
    @objc private func refreshData() {
        reloadWeatherData()
    }

    // Binds the ViewModel to update the view when the data changes
    private func bindViewModel() {
        viewModel.locations.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func startLocationUpdates() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }
        
        locationManager.startUpdatingLocation()
        activityIndicator.startAnimating()
    }

    @objc private func registerButtonTapped() {
        // Desempaquetar navigationController
        guard let navigationController = navigationController else {
            // Manejar el caso en que no haya un navigationController
            return
        }
        
        let locationRegistrationCoordinator = LocationRegistrationCoordinator(
            navigationController: navigationController, // Aquí ya está desempaquetado
            locationRepository: viewModel.locationRepository,
            weatherRepository: viewModel.weatherRepository,
            weatherStatusViewController: self // Pasa la referencia de la vista actual
        )
        
        locationRegistrationCoordinator.start()
    }

    
    // MARK: - CLLocationManagerDelegate
    
    // Handles location authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async { [weak self] in
                self?.startLocationUpdates()
            }
        case .denied, .restricted:
            print("Location access denied/restricted.")
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        let locationEntity = LocationEntity(
            id: UUID(),
            cityName: "",
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude
        )
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
        activityIndicator.stopAnimating()
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    // Defines the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.hasCurrentLocationWeather || !viewModel.userAddedLocations.isEmpty ? 2 : 1
    }

    // Defines the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.hasCurrentLocationWeather ? 1 : 0
        } else {
            return viewModel.userAddedLocations.count
        }
    }

    // Defines the titles for the sections in the table view
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && viewModel.hasCurrentLocationWeather {
            return "Current Location"
        } else if section == 1 && !viewModel.userAddedLocations.isEmpty {
            return "User-added Locations"
        }
        return nil
    }

    // Configures each cell in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherStatusCell", for: indexPath) as! WeatherStatusTableViewCell
        
        let location: LocationEntity
        if indexPath.section == 0 {
            location = viewModel.currentLocationWeather!
        } else {
            // Invertir el orden de las celdas
            location = viewModel.userAddedLocations.reversed()[indexPath.row]
        }

        cell.selectionStyle = .none
        cell.configure(with: location.toDomainLocation())
        return cell
    }

    // Handles swipe to delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section != 0 {
            // Invertir el orden de los datos para eliminar el correcto
            let reversedIndex = viewModel.userAddedLocations.count - 1 - indexPath.row
            viewModel.deleteLocation(at: reversedIndex)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Handles cell selection in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location: Location
        if indexPath.section == 0 {
            location = viewModel.currentLocationWeather!.toDomainLocation()
        } else {
            location = viewModel.userAddedLocations.reversed()[indexPath.row].toDomainLocation()
        }

        let detailViewController = WeatherDetailViewController(location: location)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
