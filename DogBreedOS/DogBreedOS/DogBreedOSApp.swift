//
//  DogBreedOSApp.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-30.
//

import SwiftUI
import OpenspanCore

@main
struct DogBreedOSApp: App {
    let container: AppContainer = AppContainer.shared
    
    init() {
        initializeSDK()
    }
    
    var body: some Scene {
        WindowGroup {
            DogBreedsView(viewModel: container.resolve(DogBreedsViewModel.self)!)
        }
    }
    
    // MARK: - SDK Initialization
    
    private func initializeSDK() {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("Plist file not found. SDK is not initialized.")
            return
        }
        
        guard let baseUrl = dict["BASE_URL"] as? String else {
            print("Base URL not found. SDK is not initialized.")
            return
        }
        
        OpenSpanCore.shared.initializeSDK(baseUrl: baseUrl)
    }
}
