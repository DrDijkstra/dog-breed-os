//
//  RequestRouter.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

import Foundation
import Alamofire

enum RequestRouter: URLRequestConvertible {
    case breedList
    case randomPhoto(request: ApiRandomBreedImageRequest)
    
    static var baseUrl: URL = URL(string: "https://your-api-base-url.com")!
    
    var method: HTTPMethod {
        switch self {
        case .breedList, .randomPhoto:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .breedList:
            return ApiUrl.breedList.path
        case .randomPhoto(let request):
            return ApiUrl.randomPhoto(breed: request.breed).path
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try getFullUrl()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .breedList, .randomPhoto:
            break
        }
        return urlRequest
    }
    
    func getFullUrl() throws -> URL {
        return RequestRouter.baseUrl.appendingPathComponent(path)
    }
}
