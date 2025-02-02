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
    
    // MARK: - Equatable Conformance
    
    public static func == (lhs: BreedInfo, rhs: BreedInfo) -> Bool {
        guard lhs.name == rhs.name else {
            return false
        }
        
        if let lhsSubBreeds = lhs.subBreeds, let rhsSubBreeds = rhs.subBreeds {
            return lhsSubBreeds == rhsSubBreeds
        } else {
            return lhs.subBreeds == nil && rhs.subBreeds == nil
        }
    }
}
