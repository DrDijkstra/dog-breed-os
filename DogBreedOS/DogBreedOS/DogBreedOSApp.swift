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
    
    let container : AppContainer = AppContainer.shared
    
    init () {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            // Access values from the dictionary
            if let baseUrl = dict["BASE_URL"] as? String {
                OpenSpanCore.shared.initializeSDK(baseUrl: baseUrl, appID: "DogBreedOS")
            }
            else{
                print("Base url not found. SDK is not initialized.")
            }
        }else{
            print("Plist url not found. SDK is not initialized.")
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            DogBreedsView(viewModel: container.resolve(DogBreedsViewModel.self)!)
        }
    }
}
