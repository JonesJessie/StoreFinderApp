//
//  NetworkService.swift
//  StoreFinderApp
//
//  Created by Mac User on 8/4/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import Moya
//i'll remove after review bc github page is set to public
private let apiKey = "M_EEbNf3lPkqQYuWVQagc_Gd2Bt50Go-3wf7AyLqv4hhi-OiYpEGN9zVrUj72mIr3R4uDdS9Sp57sKzq4kkxi5l3No8GFWwD-I8ApiQKaoNR4nSVgMgiDiVRJkhHXXYx"

enum YelpService {
    enum BusinessesProvider: TargetType {
        case search(lat: Double, long: Double)
        case details(id: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(parameters: ["latitude": lat, "longitude": long, "limit": 15], encoding: URLEncoding.queryString)
            case .details:
                return .requestPlain
            }
        }
        
        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
        
        
    }
    
}
