//
//  TopStoriesEndpoint.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation
enum TopStoriesEndpoint {
    case home
}

extension TopStoriesEndpoint: RequestProtocol {
    
    var path: String {
        switch self {
        case .home:
            return "home.json"
            
        }
    }

    var method: RequestMethod {
        switch self {
        case .home:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .home:
            return URLEncoding.queryString
        }
    }

    var headers: ReaquestHeaders? {
        switch self {
        case .home:
            return nil
        }
    }

    var parameters: RequestParameters? {
        switch self {
        case .home:
            return ["api-key": AppConstant.apiKey]
        }
    }

}
