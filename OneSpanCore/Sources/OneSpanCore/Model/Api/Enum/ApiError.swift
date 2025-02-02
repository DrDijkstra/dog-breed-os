//
//  ApiError.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

import Foundation

enum ApiError: Error, Equatable {
    case invalidRequest(String)
    case networkError(NetworkError)
    case invalidResponse
    case decodingError(DecodingErrorWrapper)
    case unknownError

    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest(let lhsMessage), .invalidRequest(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError == rhsError
        case (.invalidResponse, .invalidResponse):
            return true
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError == rhsError
        case (.unknownError, .unknownError):
            return true
        default:
            return false
        }
    }
}

struct NetworkError: Error, Equatable {
    let underlyingError: String

    init(_ error: Error) {
        self.underlyingError = error.localizedDescription
    }
}

struct DecodingErrorWrapper: Error, Equatable {
    let underlyingError: String

    init(_ error: Error) {
        self.underlyingError = error.localizedDescription
    }
}

