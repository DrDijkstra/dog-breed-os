# Dog Breed Project

Welcome to the **Dog Breed** project! This project is designed to display images of all dog breeds randomly in an iOS app. To achieve this, we are collecting data from the [Dog CEO](https://dog.ceo/dog-api/) API and storing it in a cache for efficient access. The project is built using **SwiftUI** and follows the **MVVM (Model-View-ViewModel)** architecture to ensure a clean and maintainable codebase.

---

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Usage](#usage)
7. [API Integration](#api-integration)
8. [Cache Implementation](#cache-implementation)
9. [UI Design](#ui-design)
10. [Dark Mode and Light Mode Support](#dark-mode-and-light-mode-support)
11. [Contributing](#contributing)
12. [License](#license)

---

## Introduction
The Dog Breed project is an iOS application that fetches and displays images of various dog breeds using the [Dog CEO](https://dog.ceo/dog-api/) API. The app showcases these images in a visually appealing waterfall grid layout, along with the breed names. Built entirely with **SwiftUI**, the app supports both dark mode and light mode, ensuring a seamless user experience across different device settings. The project follows the **MVVM architecture** to separate concerns and improve scalability.

---

## Features
- **Random Dog Breed Images**: Fetches and displays random images of dog breeds.
- **Waterfall Grid Layout**: Displays images and breed names in a beautiful grid format.
- **Dark Mode and Light Mode**: Supports both dark and light themes for better user experience.
- **Caching**: Implements caching to store fetched data for efficient access and reduced API calls.
- **Responsive Design**: Ensures the app looks great on all iOS devices.
- **SwiftUI**: Built entirely using SwiftUI for a modern and declarative UI.
- **MVVM Architecture**: Follows the Model-View-ViewModel pattern for a clean and maintainable codebase.

---

## Architecture
The project follows the **MVVM (Model-View-ViewModel)** architecture, which separates the application into three main components:

1. **Model**:
   - Represents the data and business logic.
   - Includes data structures for dog breeds and API response handling.

2. **View**:
   - Responsible for displaying the UI and capturing user interactions.
   - Built entirely using **SwiftUI** components like `List`, `Grid`, and custom views.

3. **ViewModel**:
   - Acts as a bridge between the Model and the View.
   - Handles data fetching, transformation, and presentation logic.
   - Uses `@Published` properties and `ObservableObject` to notify the View of data changes.

### Benefits of MVVM with SwiftUI:
- **Declarative UI**: SwiftUI simplifies UI development with its declarative syntax.
- **Data Binding**: Seamless data binding between the View and ViewModel using `@State`, `@Binding`, and `@ObservedObject`.
- **Testability**: Easier to write unit tests for ViewModel and Model.
- **Maintainability**: Clean and organized codebase, making it easier to extend and debug.

---

## Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

---

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/dog-breed-project.git
   ```
2. Open the project in Xcode:
   ```bash
   cd dog-breed-project
   open DogBreedProject.xcodeproj
   ```
3. Install dependencies (if any) using Swift Package Manager or CocoaPods.
4. Build and run the project on a simulator or physical device.

---

## Usage
1. Launch the app.
2. The app will automatically fetch and display random dog breed images in a waterfall grid layout.
3. Scroll through the list to view more images and breed names.
4. Switch between dark mode and light mode using the device settings.

---

## API Integration
The app uses the [Dog CEO API](https://dog.ceo/dog-api/) to fetch dog breed images. Key endpoints include:
- **Fetch Random Images**: `https://dog.ceo/api/breeds/image/random`
- **Fetch Breed List**: `https://dog.ceo/api/breeds/list/all`

The API responses are parsed and mapped to Swift models for easy access and display. The `URLSession` and `Codable` protocols are used for network requests and JSON parsing.

---

## Cache Implementation
To improve performance and reduce API calls, the app implements a caching mechanism:
- **Memory Cache**: Stores recently fetched images in memory for quick access.
- **Disk Cache**: Persists data on disk for offline access.

---

## UI Design
The app uses a **waterfall grid layout** to display dog breed images and names. Key SwiftUI components include:
- **LazyVGrid**: For creating a responsive grid layout.
- **AsyncImage**: For loading and displaying images asynchronously.
- **Custom Views**: For rendering each dog breed image and name.

---

## Dark Mode and Light Mode Support
The app supports both dark mode and light mode:
- Uses **SwiftUI system colors** (e.g., `Color.primary`, `Color.secondary`) to automatically adapt to the device's appearance settings.
- Ensures readability and visual appeal in both modes.

---

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push to the branch.
4. Submit a pull request with a detailed description of your changes.

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

--- 

Enjoy exploring the world of dog breeds with this app! 🐶
