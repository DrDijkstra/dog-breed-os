# Dog Breed Project

Welcome to the **Dog Breed** project! This project is designed to display images of all dog breeds randomly in an iOS app. To achieve this, we are collecting data from the [Dog CEO](https://dog.ceo/dog-api/) API and storing it in a cache for efficient access. The project is built using **SwiftUI**, follows the **MVVM (Model-View-ViewModel)** architecture, and leverages **Alamofire** for networking and **Swinject** for dependency injection. The architecture is divided into two main layers: **App Layer** and **Network Layer**.

<img src="./Resources/demo.gif" alt="Project Demo" width="180">

---

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Architecture](#architecture)
   - [App Layer](#app-layer)
   - [Network Layer](#network-layer)
   - [Dependency Injection with Swinject](#dependency-injection-with-swinject)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Usage](#usage)
7. [API Integration](#api-integration)
8. [Cache Implementation](#cache-implementation)
9. [UI Design](#ui-design)
10. [Dark Mode and Light Mode Support](#dark-mode-and-light-mode-support)
11. [Dependencies](#dependencies)
12. [Contributing](#contributing)

---

## Introduction
The Dog Breed project is an iOS application that fetches and displays images of various dog breeds using the [Dog CEO](https://dog.ceo/dog-api/) API. The app showcases these images in a visually appealing waterfall grid layout, along with the breed names. Built entirely with **SwiftUI**, the app supports both dark mode and light mode, ensuring a seamless user experience across different device settings. The project follows the **MVVM architecture**, uses **Alamofire** for networking, and **Swinject** for dependency injection. The architecture is structured into two main layers: **App Layer** and **Network Layer**.

---

## Features
- **Random Dog Breed Images**: Fetches and displays random images of dog breeds.
- **Waterfall Grid Layout**: Displays images and breed names in a beautiful grid format.
- **Dark Mode and Light Mode**: Supports both dark and light themes for better user experience.
- **Caching**: Implements caching to store fetched data for efficient access and reduced API calls.
- **Responsive Design**: Ensures the app looks great on all iOS devices.
- **SwiftUI**: Built entirely using SwiftUI for a modern and declarative UI.
- **MVVM Architecture**: Follows the Model-View-ViewModel pattern for a clean and maintainable codebase.
- **Layered Architecture**: Separates concerns into **App Layer** and **Network Layer** for better organization and scalability.
- **Alamofire**: Used for efficient and easy networking.
- **Swinject**: Used for dependency injection to manage dependencies and improve testability.

---

## Architecture
The project follows the **MVVM (Model-View-ViewModel)** architecture and is divided into two main layers:

### 1. App Layer
The **App Layer** is responsible for the UI and business logic of the application. It includes the following components:

- **View**:
  - Built using **SwiftUI** components like `LazyVGrid`, `AsyncImage`, and custom views.
  - Displays dog breed images and names in a waterfall grid layout.
  - Handles user interactions and updates the UI based on data changes.

- **ViewModel**:
  - Acts as a bridge between the **View** and the **Network Layer**.
  - Contains the business logic for fetching and processing data.
  - Uses `@Published` properties and `ObservableObject` to notify the View of data changes.
  - Example: `DogBreedViewModel` fetches data from the `OpenSpanCoreService` and prepares it for the View.

- **Model**:
  - Represents the data structures used in the app.
  - Includes models for dog breeds, API responses, and cached data.
  - Example: `CardData` model represents a dog breed with its name, image and size.

### 2. Network Layer
The **Network Layer** handles all network-related operations, including API requests, caching, and data management. It is modular and scalable, with the following components:

---

#### **Service**:
- Manages data operations (e.g., `BreedService` for fetching dog breeds).

#### **Repository**:
- Acts as the data source, deciding whether to fetch from the API or use cached/local data.

#### **API Service**:
- Manages network sessions using **Alamofire**.

#### **RequestRouter**:
- Defines API endpoints, methods, and parameters, converting them into `URLRequestConvertible`.

#### **Interceptor**:
- Modifies requests/responses (e.g., adding headers or retrying failed requests).

#### **Dependency Injection**:
- Uses **Swinject** to manage and inject dependencies, ensuring loose coupling and testability.

---

### Benefits:
1. **Modularity**: Each component has a single responsibility.
2. **Scalability**: Easy to add new features or endpoints.
3. **Testability**: Dependencies can be mocked for unit testing.
4. **Separation of Concerns**: Decoupled from the rest of the app.
5. **Flexibility**: Customizable network behavior via `RequestRouter` and `Interceptor`.

---

This structure ensures a robust, maintainable, and scalable Network Layer.

### 3. Dependency Injection with Swinject
The project uses **Swinject** for dependency injection to manage dependencies and improve testability. Swinject is a lightweight dependency injection framework for Swift that allows us to define and resolve dependencies in a clean and modular way.


---

## Requirements
- iOS 18.0+
- Xcode 16.0+
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
3. Install dependencies using Swift Package Manager (SPM):
   - Add the following dependencies to your `Package.swift` or via Xcode's SPM integration:
     ```swift
     dependencies: [
         .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0"),
         .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
     ]
     ```
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

The API responses are parsed and mapped to Swift models using `Codable`.

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

## Dependencies
The project uses the following third-party libraries via **Swift Package Manager (SPM)**:

1. **Alamofire**:
   - Used for efficient and easy networking.
   - GitHub: [https://github.com/Alamofire/Alamofire](https://github.com/Alamofire/Alamofire)
   - Version: `5.6.0` or higher.

2. **Swinject**:
   - Used for dependency injection to manage dependencies and improve testability.
   - GitHub: [https://github.com/Swinject/Swinject](https://github.com/Swinject/Swinject)
   - Version: `2.8.0` or higher.

To add these dependencies:
- Open Xcode and navigate to `File > Add Packages...`.
- Enter the repository URLs for Alamofire and Swinject.
- Select the appropriate versions and add them to your project.

---

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push to the branch.
4. Submit a pull request with a detailed description of your changes.

---

Enjoy exploring the world of dog breeds with this app! 🐶