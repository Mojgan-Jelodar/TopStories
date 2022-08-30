//
//  APIOperation.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation

final class APIOperation: OperationProtocol {

    /// The `URLSessionTask` to be executed/
    private var task: URLSessionTask?

    var requestType: RequestType

    /// Designated initializer.
    /// - Parameter request: Instance conforming to the `RequestProtocol`.
    init(_ request: RequestType) {
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
    func execute(in requestDispatcher: RequestDispatcherProtocol, completion: @escaping (OperationResult) -> Void) {
        switch requestType {
        case .api(let request):
            task = requestDispatcher.execute(request: request, completion: { result in
                switch result {
                case .success(let value):
                    completion(.data(value))
                case .failure(let error):
                    completion(.error(error))
                }
            })
        case .download(let request,let progressHandler):
            task = requestDispatcher.download(request: request, progressHandler: progressHandler, completion: { result in
                switch result {
                case .success(let url):
                    completion(.file(url))
                case .failure(let error):
                    completion(.error(error))
                }
            })
        case .upload(let url, let data, let progressHandler):
            task = requestDispatcher.upload(request: .init(url: url), data: data, progressHandler: progressHandler, completion: { result in
                switch result {
                case .success(let value):
                    completion(.data(value))
                case .failure(let error):
                    completion(.error(error))
                }
            })
        }
      
    }
}
