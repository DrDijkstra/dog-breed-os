//
//  SDKContainer.swift.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-30.
//


import Foundation
import Swinject

class SDKContainer {
    
    static var shared: SDKContainer = SDKContainer()
    
    let container = Container()
    private var baseUrl: String = ""
    private var appID: String = ""
    
    private init() {
        
    }
    
    func injectDependency(baseUrl: String, appID: String)  {
        self.baseUrl = baseUrl
        self.appID = appID
        registerServices()
    }

    private func registerServices() {
        container.register(ApiInterceptor.self) { _ in
            ApiInterceptor()
        }
        .inObjectScope(.container)
        container.register(ApiService.self) { _ in
            ApiServiceImpl(baseUrl: self.baseUrl, requestInterceptor: self.resolve(ApiInterceptor.self))
        }
        .inObjectScope(.container)
        container.register(BreedService.self) { _ in
            BreedServiceImpl(apiService:  self.resolve(ApiService.self))
        }
        .inObjectScope(.container)
        container.register(MemoryCacheService.self) { _ in
            MemoryCache()
        }
        .inObjectScope(.container)
        container.register(DiskCacheService.self) { _ in
            DiskCache(cacheDirectoryString: self.appID)
        }
        .inObjectScope(.container)
        container.register(ImageCacheService.self) { _ in
            ImageCacheService(memoryCacheService: self.resolve(MemoryCacheService.self), diskCacheService: self.resolve(DiskCacheService.self))
        }
        .inObjectScope(.container)

        container.register(OpenSpanCoreService.self) { _ in
            OpenSpanCoreServiceImpl(breedService: self.resolve(BreedService.self), imageCacheService: self.resolve(ImageCacheService.self))
        }
        .inObjectScope(.container)
        
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let service = container.resolve(type) else {
            fatalError("Dependency of type \(type) could not be resolved.")
        }
        return service
    }
}
