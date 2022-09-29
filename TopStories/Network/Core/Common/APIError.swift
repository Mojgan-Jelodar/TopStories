//
//  APIError.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation
/// Enum of API Errors
enum APIError: LocalizedError,Identifiable {
  
    
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
}
enum Reason {
    case missingURL
}
