//
//  ApiInterceptor.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


import Foundation
import Alamofire

final class ApiInterceptor: RequestInterceptor {
    
    /// Automatically logs response when a request completes
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }

}

