//
//  BreedInfo.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

public class BreedInfo: Equatable {
    
    public var name: String?
    public var subBreeds: [String]?
    
    public init(name: String? = nil, subBreeds: [String]? = nil) {
        self.name = name
        self.subBreeds = subBreeds
    }
    
    public static func == (lhs: BreedInfo, rhs: BreedInfo) -> Bool {
        return lhs.name == rhs.name && lhs.subBreeds == rhs.subBreeds
    }
}

