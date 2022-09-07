//
//  OperationProtocol.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation
protocol OperationProtocol {

    var  requestType : RequestProtocol { get }
    /// Execute a request using a request dispatcher.
    /// - Parameters:
    ///   - requestDispatcher: `RequestDispatcherProtocol` object that will execute the request.
    ///   - completion: Completion block.
    func execute(in requestDispatcher: RequestDispatcherProtocol,
                 completion: @escaping (Result<Data,APIError>) -> Void)

    /// Cancel the operation.
    func cancel()
}
