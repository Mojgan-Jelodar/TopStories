//
//  EnvironmentProtocol.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation

/// Protocol to which environments must conform.
protocol EnvironmentProtocol {
    /// The default HTTP request headers for the environment.
    var headers: ReaquestHeaders? { get }

    /// The base URL of the environment.
    var baseURL: String { get }
}
