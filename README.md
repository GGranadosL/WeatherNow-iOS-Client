# WeatherNow iOS App

**WeatherNow iOS App** es una aplicación para iOS desarrollada para WeatherNow Inc., diseñada para proporcionar información meteorológica precisa y accesible a los usuarios. La aplicación permite a los usuarios registrar ubicaciones de interés, visualizar el estado actual del clima y recibir notificaciones sobre cambios significativos en el clima.

## Características

- **Registro de Ubicaciones**: Agrega ubicaciones con detalles como nombre de la ciudad, latitud, longitud y fecha de registro.
- **Estado del Clima**: Muestra el estado actual del clima para cada ubicación registrada, incluyendo temperatura, descripción del clima e iconos representativos.
- **Notificaciones Locales**: Envía recordatorios a los usuarios para revisar el clima cuando se detectan cambios significativos.
- **Integración con API Meteorológica**: Utiliza una API pública (como OpenWeatherMap) para obtener datos del clima.
- **Uso de Core Location**: Obtiene la ubicación actual del usuario para mostrar el clima en tiempo real.
- **Persistencia Local**: Guarda ubicaciones localmente para su uso offline.
- **Interfaz Moderna y Minimalista**: Proporciona una experiencia de usuario limpia y eficiente.

## Estructura del Proyecto

- **`App/`**: Contiene el archivo `AppDelegate`, `SceneDelegate` y el coordinador principal.
- **`Domain/`**: Define los modelos, interfaces de repositorios y casos de uso.
- **`Data/`**: Implementaciones concretas de repositorios y manejo de persistencia.
- **`Presentation/`**: Contiene las vistas, controladores de vista y vistas modelo.
- **`Resources/`**: Recursos como imágenes y el storyboard de lanzamiento.
- **`Tests/`**: Pruebas unitarias y de integración.

## Instalación

1. **Clona el repositorio**:
   ```sh
   git clone https://github.com/tu-usuario/WeatherNow-iOS-App.git
   ```

2. **Abre el proyecto en Xcode**:
   ```sh
   open WeatherNow-iOS-App.xcworkspace
   ```

3. **Ejecuta el proyecto en un simulador o dispositivo**.

## Requisitos

- **Swift** y **UIKit**
- **Core Location** y **Calendar API** (sin dependencias externas)

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo `LICENSE` para más detalles.

## Contacto

Para más información, puedes contactar a Gerardo Granados en gerardo.granados@outlook.com.

