//
//  WeatherStatusViewController.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import UIKit
import CoreLocation
import EventKitUI

class WeatherStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, LocationRegistrationViewControllerDelegate {
    
    // MARK: - Properties
    
    let viewModel: WeatherStatusViewModel
    let notificationService: WeatherNotificationService
    let calendarService: CalendarService
    
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
    
    private let addReminderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Reminder", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let locationManager = CLLocationManager()
    weak var coordinator: Coordinator?
    private var debounceTimer: Timer?
    
    // MARK: - Initialization
    
    init(viewModel: WeatherStatusViewModel, notificationService: WeatherNotificationService, calendarService: CalendarService) {
        self.viewModel = viewModel
        self.notificationService = notificationService
        self.calendarService = calendarService  // Initialize CalendarService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setupView()
        bindViewModel()
        activityIndicator.startAnimating()
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
        view.addSubview(addReminderButton)  // Add the reminder button to the view
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -10),
            
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addReminderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),  // New constraints for the add reminder button
            addReminderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addReminderButton.widthAnchor.constraint(equalToConstant: 150),
            addReminderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        addReminderButton.addTarget(self, action: #selector(addReminderButtonTapped), for: .touchUpInside)  // Add action for the reminder button
    }
    
    private func requestLocationPermission() {
        // Directly request authorization without checking the status beforehand
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        } else {
            print("Location services are not enabled")
            activityIndicator.stopAnimating()
        }
    }
    
    func reloadWeatherData() {
        viewModel.loadWeatherData()
        tableView.reloadData() // This reloads the entire table view, which is safer.
        refreshControl.endRefreshing()
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
                self?.debounceTimer?.invalidate()
                self?.debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func startLocationUpdates() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }
        
        // Start updating the location if we have the proper authorization
        locationManager.startUpdatingLocation()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    @objc private func registerButtonTapped() {
        guard let navigationController = navigationController else {
            return
        }
        
        let locationRegistrationCoordinator = LocationRegistrationCoordinator(
            navigationController: navigationController,
            locationRepository: viewModel.locationRepository,
            weatherRepository: viewModel.weatherRepository,
            weatherStatusViewController: self,
            notificationService: notificationService
        )
        
        locationRegistrationCoordinator.start()
    }
    
    // MARK: - New Calendar Reminder Button Action
    
    @objc private func addReminderButtonTapped() {
        let date = Date()
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? date

        // Request access to the calendar
        calendarService.requestFullCalendarAccess { [weak self] granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self?.showPermissionAlert()
                }
                return
            }

            guard let eventStore = self?.calendarService.eventStore else {
                DispatchQueue.main.async {
                    self?.showPermissionAlert()
                }
                return
            }

            // Create a new event
            let event = EKEvent(eventStore: eventStore)
            event.title = "Check the weather"
            event.startDate = date
            event.endDate = endDate
            event.calendar = eventStore.defaultCalendarForNewEvents

            // Present the event editing UI
            DispatchQueue.main.async {
                let eventEditVC = EKEventEditViewController()
                eventEditVC.event = event
                eventEditVC.eventStore = eventStore
                eventEditVC.editViewDelegate = self
                self?.present(eventEditVC, animated: true, completion: nil)
            }
        }
    }

    private func showPermissionAlert() {
        let alertController = UIAlertController(
            title: "Calendar Access Required",
            message: "Calendar access is required to add reminders. Please go to Settings -> Privacy -> Calendar to enable access.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // Handle the user's response in the delegate method
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            requestLocationPermission()
            break
        case .restricted, .denied:
            print("Location access denied/restricted.")
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async { [weak self] in
                self?.startLocationUpdates()
            }
        @unknown default:
            break
        }
    }
    
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        print("Location updated: \(currentLocation)")
        DispatchQueue.global(qos: .background).async { [weak self] in
            let locationEntity = LocationEntity(
                id: UUID(),
                cityName: "",
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude
            )
            self?.processLocation(locationEntity)
        }
    }
    
    private func processLocation(_ locationEntity: LocationEntity) {
        
        viewModel.addLocation(locationEntity, isCurrentLocation: true)
        print("processLocation: \(locationEntity)")
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
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
            let reversedIndex = viewModel.userAddedLocations.count - 1 - indexPath.row
            viewModel.deleteLocation(at: reversedIndex)
            
            // You must notify the table view that a row has been deleted
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: nil)
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

extension WeatherStatusViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .canceled:
            print("Event creation canceled")
        case .saved:
            print("Event saved successfully")
        case .deleted:
            print("Event deleted")
        @unknown default:
            print("Unknown action")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

