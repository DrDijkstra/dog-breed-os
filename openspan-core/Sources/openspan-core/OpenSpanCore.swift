//
//  OpenSpanCore.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

public class OpenSpanCore {
    static let shared = OpenSpanCore()
    
    public var openSpanCoreService: OpenSpanCoreService?
     
    private init() {
        
    }
    
    public func initializeSDK (baseUrl: String) {
        SDKContainer.shared.injectDependency(baseUrl: baseUrl)
        openSpanCoreService = SDKContainer.shared.resolve(OpenSpanCoreService.self)
    }
}
