//
//  RequestRouter.swift
//  openspan-core
//
//  Created by Sanjay Dey on 2025-01-29.
//

import Foundation
import Alamofire


enum RequestRouter : URLRequestConvertible, URLConvertible{
    case breedList
    case randomPhoto(breed: String)
    
    static var baseUrl = ""
    
    var method: HTTPMethod {
        switch self {
        case .breedList, .randomPhoto:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .breedList, .randomPhoto:
            return ApiUrl.breedList.path
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: try getFullUrl())
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .breedList, .randomPhoto:
            break
        }
        return urlRequest
    }
    
    public func getFullUrl()throws -> URL{
        return try RequestRouter.baseUrl.asURL().appendingPathComponent(path)
    }
    
    func asURL() throws -> URL {
        return URL(string: path)!
    }

}
