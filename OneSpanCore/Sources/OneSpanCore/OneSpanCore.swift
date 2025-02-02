//
//  OpenSpanCore.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

public class OneSpanCore {
    
    public static let shared = OneSpanCore()
    
    public var openSpanCoreInteractor: OneSpanCoreInteractor?
     
    private init() {
        
    }
    
    public func initializeSDK (baseUrl: String) {
        SDKContainer.shared.injectDependency(baseUrl: baseUrl)
        openSpanCoreInteractor = SDKContainer.shared.resolve(OneSpanCoreInteractor.self)
    }
}
