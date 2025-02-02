//
//  AppContainer.swift
//  DogBreedOS
//
//  Created by Sanjay Dey on 2025-01-31.
//

import Foundation
import Swinject
import OneSpanCore

class AppContainer {
    static let shared: AppContainer = .init()
    let container = Container()
    
    private init() {
        registerServices()
    }
    
    private func registerServices() {

        container.register(OneSpanCoreInteractor.self) { _ in
            return OneSpanCore.shared.oneSpanCoreInteractor!
        }
        .inObjectScope(.container)
        
        container.register(WaterfallGridViewModel.self) { resolver in
            return WaterfallGridViewModel(numberOfColumns: 2)
        }
        .inObjectScope(.container)
        
        container.register(CardImageProvider.self) { resolver in
            return self.resolve(WaterfallGridViewModel.self)!
        }
        .inObjectScope(.transient)
        
        container.register(DogBreedsViewModel.self) { resolver in
            let interactor = resolver.resolve(OneSpanCoreInteractor.self)!
            let cardImageProvider = resolver.resolve(CardImageProvider.self)!
            let model = DogBreedsViewModel(interactor: interactor, cardImageProvider: cardImageProvider)
            return model
        }
        .inObjectScope(.transient)
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
