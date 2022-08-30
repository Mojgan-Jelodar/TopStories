//
//  APIEnvironment.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation

enum APIEnvironment: EnvironmentProtocol {

    case development
    case production

    var headers: ReaquestHeaders? {
        return nil
    }

    var baseURL: String {
        return "https://api.nytimes.com/svc/topstories/v2/"
    }

}
