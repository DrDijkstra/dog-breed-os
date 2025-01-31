//
//  AppContainer.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import Foundation
import Swinject

class AppContainer {
    static let shared: AppContainer = .init()
    let container = Container()
    
    private init() {
        registerServices()
    }
    
    private func registerServices() {
        container.register(DogBreedsViewModel.self) { _ in
            DogBreedsViewModel()
        }
        .inObjectScope(.transient)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let service = container.resolve(type) else {
            fatalError("Dependency of type \(type) could not be resolved.")
        }
        return service
    }
    
}
