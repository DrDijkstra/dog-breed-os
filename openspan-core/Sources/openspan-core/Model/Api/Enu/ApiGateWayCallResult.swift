//
//  ApiGateWayCallResult.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


import Foundation

public enum ApiGateWayCallResult<T> {
    case success(T)
    case failure(Error)      
}