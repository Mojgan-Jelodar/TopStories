//
//  APIError.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation
/// Enum of API Errors
enum APIError: LocalizedError,Identifiable,Equatable {
    
    case parameterEncodingFailed(reason: Reason)
    /// No data received from the server.
    case noData
    /// The server response was invalid (unexpected format).
    case invalidResponse
    /// The request was rejected: 400-499
    case badRequest(String?)
    /// Encoutered a server error.
    case serverError(String?)
    /// There was an error parsing the data.
    case parseError(String?)
    /// Unknown error.
    case unknown
    
    var id: String {
        self.localizedDescription
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs,rhs) {
        case (.noData,.noData),(.invalidResponse,.invalidResponse),(.unknown,.unknown):
            return true
        case (.badRequest(let lhs),.badRequest(let rhs)):
            return rhs == lhs
        case (.serverError(let lhs),.serverError(let rhs)):
            return rhs == lhs
        case (.parseError(let lhs),.parseError(let rhs)):
            return rhs == lhs
        case (.parameterEncodingFailed(let lhs),.parameterEncodingFailed(let rhs)):
            return rhs == lhs
        default:
            return false
        }
    }
}
enum Reason {
    case missingURL
}
