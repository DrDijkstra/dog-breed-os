//
//  BreedImageInfoResponse.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

public class BreedImageInfoResponse : Equatable {
    
    public var imageUrl: String?
    
    public init(imageUrl: String? = nil) {
        self.imageUrl = imageUrl
    }
    
    public static func == (lhs: BreedImageInfoResponse, rhs: BreedImageInfoResponse) -> Bool {
        return lhs.imageUrl == rhs.imageUrl
    }
}
