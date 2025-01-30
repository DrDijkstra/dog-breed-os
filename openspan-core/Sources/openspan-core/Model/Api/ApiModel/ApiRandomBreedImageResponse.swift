//
//  ApiRandomBreedImageRequest 2.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//


class ApiRandomBreedImageResponse: BaseResponse {
    var message: String?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case status
    }
    
    init(message: String? = nil, status: String? = nil) {
        self.message = message
        self.status = status
        super.init()
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        super.init()
    }
}

