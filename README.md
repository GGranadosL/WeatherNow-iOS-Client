# WeatherNow iOS App

![WeatherNow Logo](Resources/assets/appstore.png)

**WeatherNow iOS App** is an iOS application developed for WeatherNow Inc., designed to provide accurate and accessible weather information to users. The app allows users to register locations of interest, view current weather conditions, and receive notifications about significant weather changes.

## Features

- **Location Registration**: Add locations with details such as city name, latitude, longitude, and registration date.
- **Weather Status**: Display the current weather status for each registered location, including temperature, weather description, and representative icons.
- **Local Notifications**: Send reminders to users to check the weather when significant changes are detected.
- **Weather API Integration**: Utilizes a public API (like OpenWeatherMap) to fetch weather data.
- **Core Location Usage**: Retrieves the user's current location to display real-time weather.
- **Local Persistence**: Saves locations locally for offline use.
- **Modern and Minimalist Interface**: Provides a clean and efficient user experience.
- **Keychain Integration**: Securely stores sensitive user data using Keychain.
- **Calendar Integration**: Allows users to add reminders to their device's calendar to check the weather.
- **API Calls**: Implements API calls for fetching weather by location and by city name.
- **Unit and Integration Tests**: Comprehensive testing ensures reliability and performance.

## Project Structure

- **`App/`**: Contains the `AppDelegate`, `SceneDelegate`, and the main coordinator.
- **`Domain/`**: Defines models, repository interfaces, and use cases.
- **`Data/`**: Concrete implementations of repositories and data persistence.
- **`Presentation/`**: Contains views, view controllers, and view models.
- **`Resources/`**: Resources like images and the launch storyboard.
- **`Tests/`**: Unit tests and integration tests to validate functionality.

## Installation

1. **Clone the repository**:
   ```sh
   git clone https://github.com/your-username/WeatherNow-iOS-App.git
    ```
2. **Open the project in Xcode:**:
   ```sh
   open WeatherNow-iOS-App.xcworkspace
   ```

3. **Run the project on a simulator or device.**.

## Requirements

- **Swift** y **UIKit**
- **Core Location** y **Calendar API** (no external dependencies)

## Contacto

For more information, you can contact Gerardo Granados at gerardo.granados@outlook.com.

