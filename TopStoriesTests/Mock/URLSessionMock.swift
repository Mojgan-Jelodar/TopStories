//
//  URLSessionDataTaskMock.swift
//  TopStoriesTests
//
//  Created by Mozhgan on 9/7/22.
//

import Foundation
@testable import TopStories
//protocol URLSessionProtocol {
//    associatedtype DataTask: URLSessionDataTaskProtocol
//    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTask
//}
//protocol URLSessionDataTaskProtocol {
//    func resume()
//}
//extension URLSession: URLSessionProtocol {}
//extension URLSessionDataTask: URLSessionDataTaskProtocol { }

final class URLSessionDataTaskMock:  URLSessionDataTaskProtocol {
    func cancel() {
        //self.c
    }
    
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}

final class URLSessionMock: URLSessionProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // data and error can be set to provide data or an error
    var data: Data?
    var error: Error?
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTaskMock {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
