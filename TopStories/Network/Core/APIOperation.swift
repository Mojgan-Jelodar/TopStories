//
//  APIOperation.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation

final class APIOperation: OperationProtocol {
    
    /// The `URLSessionTask` to be executed/
    private var task: URLSessionDataTaskProtocol?

    var requestType: RequestProtocol

    /// Designated initializer.
    /// - Parameter request: Instance conforming to the `RequestProtocol`.
    init(_ request: RequestProtocol) {
        self.requestType = request
    }

    /// Cancels the operation and the encapsulated task.
    func cancel() {
        task?.cancel()
    }

    /// Execute a request using a request dispatcher.
    /// - Parameters:
    ///   - requestDispatcher: `RequestDispatcherProtocol` object that will execute the request.
    ///   - completion: Completion block.
    func execute(in requestDispatcher: RequestDispatcherProtocol,
                 completion: @escaping (Result<Data,APIError>) -> Void) {
        task = requestDispatcher.execute(request: self.requestType, completion: { result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
