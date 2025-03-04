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
    
    private init() {
        
    }
    
    func injectDependency(baseUrl: String)  {
        self.baseUrl = baseUrl
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
        
        container.register(MemoryCacheRepository.self) { _ in
            MemoryCacheRepositoryImpl()
        }
        .inObjectScope(.container)
        
        container.register(DiskImageCacheRepository.self) { _ in
            DiskImageCacheRepositoryImpl()
        }
        .inObjectScope(.container)
        
        container.register(ImageCacheService.self) { _ in
            ImageCacheService(memoryCacheRepository: self.resolve(MemoryCacheRepository.self), diskCacheRepository: self.resolve(DiskImageCacheRepository.self))
        }
        .inObjectScope(.container)
        
        container.register(DownloadService.self) { _ in
            DownloadServiceImpl(apiService: self.resolve(ApiService.self))
        }
        .inObjectScope(.container)

        container.register(OneSpanCoreInteractor.self) { _ in
            OneSpanCoreInteractorImpl(breedService: self.resolve(BreedService.self), imageCacheService: self.resolve(ImageCacheService.self), downloadService: self.resolve(DownloadService.self))
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
