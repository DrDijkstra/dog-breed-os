//
//  ApiCallResult.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


public enum ApiCallResult <T>{
    case success(sc : T)
    case failure(error : ResponseStatus)
}