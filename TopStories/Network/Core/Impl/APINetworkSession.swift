//
//  APINetworkSession.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation
final class APINetworkSession: NSObject {

    deinit {
        // We have to invalidate the session becasue URLSession strongly retains its delegate. https://developer.apple.com/documentation/foundation/urlsession/1411538-invalidateandcancel
        session.invalidateAndCancel()
        session = nil
    }

    /// The URLSession handing the URLSessionTaks.
    var session: URLSession!

    /// A typealias describing a progress and completion handle tuple.
    private typealias ProgressAndCompletionHandlers = (progress: ProgressHandler?, completion: ((URL?, URLResponse?, Error?) -> Void)?)

    /// Dictionary containing associations of `ProgressAndCompletionHandlers` to `URLSessionTask` instances.
    private var taskToHandlersMap: [URLSessionTask: ProgressAndCompletionHandlers] = [:]

    /// Designated initializer.
    /// - Parameters:
    ///   - configuration: `URLSessionConfiguration` instance.
    ///   - delegateQueue: `OperationQueue` instance for scheduling the delegate calls and completion handlers.
    public init(configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
        super.init()
        self.session = URLSession(configuration: configuration,
                                  delegate: self,
                                  delegateQueue: delegateQueue)
    }

    /// Associates a `URLSessionTask` instance with its `ProgressAndCompletionHandlers`
    /// - Parameters:
    ///   - handlers: `ProgressAndCompletionHandlers` tuple.
    ///   - task: `URLSessionTask` instance.
    private func set(handlers: ProgressAndCompletionHandlers?, for task: URLSessionTask) {
        taskToHandlersMap[task] = handlers
    }

    /// Fetches the `ProgressAndCompletionHandlers` for a given `URLSessionTask`.
    /// - Parameter task: `URLSessionTask` instance.
    /// - Returns: `ProgressAndCompletionHandlers` optional instance.
    private func getHandlers(for task: URLSessionTask) -> ProgressAndCompletionHandlers? {
        return taskToHandlersMap[task]
    }

}
extension APINetworkSession: NetworkSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        return dataTask
    }

    func downloadTask(request: URLRequest, progressHandler: ProgressHandler? = nil, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        let downloadTask = session.downloadTask(with: request)
        //  Remove the associated handlers.
        set(handlers: (progressHandler, completionHandler), for: downloadTask)
        return downloadTask
    }

    func uploadTask(with request: URLRequest, from fileURL: URL, progressHandler: ProgressHandler? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        let uploadTask = session.uploadTask(with: request, fromFile: fileURL, completionHandler: { (data, urlResponse, error) in
            completion(data, urlResponse, error)
        })
        set(handlers: (progressHandler, nil), for: uploadTask)
        return uploadTask
    }
}

extension APINetworkSession: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let handlers = getHandlers(for: downloadTask) else {
            return
        }
        DispatchQueue.main.async {
            handlers.completion?(location, downloadTask.response, downloadTask.error)
        }
        //  Remove the associated handlers.
        set(handlers: nil, for: downloadTask)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let handlers = getHandlers(for: downloadTask) else {
            return
        }

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            handlers.progress?(progress)
        }
    }
}
