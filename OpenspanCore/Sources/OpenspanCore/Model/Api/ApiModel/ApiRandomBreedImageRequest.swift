//
//  ApiRandomBreedImageRequest.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

class ApiRandomBreedImageRequest: BaseRequest {
    let breed: String
    
    enum CodingKeys: String, CodingKey {
        case breed
    }
    
    init(breed: String) {
        self.breed = breed
        super.init()
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.breed = try container.decode(String.self, forKey: .breed)
        super.init()
    }
}
