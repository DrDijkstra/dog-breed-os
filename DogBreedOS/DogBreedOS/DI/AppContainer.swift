//
//  AppContainer.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import Foundation
import Swinject
import OpenspanCore

class AppContainer {
    static let shared: AppContainer = .init()
    let container = Container()
    
    private init() {
        registerServices()
    }
    
    private func registerServices() {

        container.register(OpenSpanCoreService.self) { _ in
            return OpenSpanCore.shared.openSpanCoreService!
        }
        .inObjectScope(.container)
        
        container.register(WaterfallGridViewModel.self) { resolver in
            return WaterfallGridViewModel(numberOfColumns: 2)
        }
        .inObjectScope(.container)
        
        container.register(BreedImageProvider.self) { resolver in
            return self.resolve(WaterfallGridViewModel.self)!
        }
        .inObjectScope(.transient)
        
        container.register(DogBreedsViewModel.self) { resolver in
            let openSpanCoreService = resolver.resolve(OpenSpanCoreService.self)!
            let breedImageProvider = resolver.resolve(BreedImageProvider.self)!
            let model = DogBreedsViewModel(openSpanCoreService: openSpanCoreService, breedImageProvider: breedImageProvider)
            return model
        }
        .inObjectScope(.transient)
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
