//
//  ApiUrl.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


import Foundation

enum ApiUrl {
    case breedList
    case randomPhoto(breed: String)
    
    var path: String {
        switch self {
        case .breedList:
            return "breeds/list/all"
        case .randomPhoto(let breed):
            return "breed/\(breed)/images/random"
        }
    }
    
}
