//
//  OperationResult.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation

/// Protocol to which a request dispatcher must conform to.
protocol RequestDispatcherProtocol {

    /// Required initializer.
    /// - Parameters:
    ///   - environment: Instance conforming to `EnvironmentProtocol` used to determine on which environment the requests will be executed.
    ///   - networkSession: Instance conforming to `NetworkSessionProtocol` used for executing requests with a specific configuration.
    init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol)

    /// Executes a request.
    /// - Parameters:
    ///   - request: Instance conforming to `RequestProtocol`
    ///   - completion: Completion handler.
    func execute(request: RequestProtocol, completion: @escaping (Result<Data,APIError>) -> Void) -> URLSessionTask
    
    /// Executes a request.
    /// - Parameters:
    ///   - request: Instance conforming to `request`
    ///   - completion: Completion handler.
    
    func download(request: URLRequest,progressHandler : ProgressHandler?, completion: @escaping (Result<URL,APIError>) -> Void) -> URLSessionTask
    
    /// Executes a request.
    /// - Parameters:
    ///   - url: the path for upload file
    ///   - completion: Completion handler.
    func upload(request: URLRequest, data : Data ,progressHandler : ProgressHandler?,completion: @escaping (Result<Data,APIError>) -> Void) -> URLSessionTask
}
