//
//  BreedInfo.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

public class BreedInfo {
    
    public var name: String?
    public var subbreeeds: [String]?
    
    public init(name: String? = nil, subbreeeds: [String]? = nil) {
        self.name = name
        self.subbreeeds = subbreeeds
    }
}
