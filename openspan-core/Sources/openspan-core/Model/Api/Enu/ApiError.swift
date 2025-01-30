//
//  ApiError.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


enum ApiError: Error {
    case invalidRequest(String)
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case unknownError
}