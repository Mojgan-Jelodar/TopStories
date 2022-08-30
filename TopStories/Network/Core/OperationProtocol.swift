//
//  OperationProtocol.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation

enum RequestType {
    /// Will translate to a URLSessionDataTask.
    case api(request : RequestProtocol)
    /// Will translate to a URLSessionDownloadTask.
    case download(request : URLRequest,progressHandler :ProgressHandler?)
    /// Will translate to a URLSessionUploadTask.
    case upload(url : URL,data : Data,progressHandler : ProgressHandler?)
}

/// The expected result of an API Operation.
enum OperationResult {
    /// JSON reponse.
    case data(_ : Any?)
    /// A downloaded file with an URL.
    case file(_ : URL?)
    /// An error.
    case error(_ : APIError)
}

protocol OperationProtocol {

    var  requestType : RequestType { get }
    /// Execute a request using a request dispatcher.
    /// - Parameters:
    ///   - requestDispatcher: `RequestDispatcherProtocol` object that will execute the request.
    ///   - completion: Completion block.
    func execute(in requestDispatcher: RequestDispatcherProtocol,
                 completion: @escaping (OperationResult) -> Void)

    /// Cancel the operation.
    func cancel()
}
