//
//  StoryListInteractorTests.swift
//  TopStoriesTests
//
//  Created by Mozhgan on 9/7/22.
//

import Foundation
import XCTest
import OSLog
@testable import TopStories
final class StoryListInteractorTests : XCTestCase {
    private var subjectUnderTest : StoryListInteractor!
    private var networkManager : MockTopStoryNetworkManager!
    
    override func setUp() {
        networkManager = .init()
        subjectUnderTest = .init(worker: networkManager)
    }
    override func tearDown() {
        subjectUnderTest = nil
        networkManager = nil
    }
    func testFetch() {
        let expectation = XCTestExpectation(description: "revoking api")
        var stories : Stories?
        subjectUnderTest.fetch { result in
            switch result {
            case .success(let value):
                stories = value
            case .failure(let error):
                os_log(.error, "Failed loading the data : %@", error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        XCTAssert(stories == Stories.mock)
    }
    
}
extension StoryListInteractorTests {
    final class MockTopStoryNetworkManager :TopStoryNetworkManagerProtocol {
        private lazy var requestDispatcher : MockRequestDispatcher = {
            .init(environment: APIEnvironment.production,
                  networkSession: MockNetworkSession())
        }()
        func home(completionHandler: @escaping (Result<Stories, APIError>) -> Void) -> OperationProtocol? {
            let operation = MockOperation(TopStoriesEndpoint.home)
            operation.execute(in: requestDispatcher) { result in
                switch result {
                case .success(let data):
                    // swiftlint:disable force_try
                    completionHandler(.success(try! .init(data: data)))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
            return operation
        }
    }
}
extension StoryListInteractorTests {
    final class MockOperation: OperationProtocol {
        
        private var task: URLSessionDataTaskProtocol?
        
        var requestType: RequestProtocol
        
        init(_ request: RequestProtocol) {
            self.requestType = request
        }
        
        /// Cancels the operation and the encapsulated task.
        func cancel() {
            task?.cancel()
        }
        
        func execute(in requestDispatcher: RequestDispatcherProtocol,
                     completion: @escaping (Result<Data,APIError>) -> Void) {
            self.task =  requestDispatcher.execute(request: requestType) { result in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}

extension StoryListInteractorTests {
    final class MockRequestDispatcher : RequestDispatcherProtocol {
        let environment: EnvironmentProtocol
        let networkSession: NetworkSessionProtocol
        init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol) {
            self.networkSession = networkSession
            self.environment = environment
        }
        
        func execute(request: RequestProtocol, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTaskProtocol? {
            let urlRequest = request.urlRequest(with: self.environment)!
            return networkSession.dataTask(with: urlRequest) { data, _, error in
                guard let data = data else {
                    completion(.failure(.serverError(error?.localizedDescription ?? "")))
                    return
                }
                completion(.success(data))
            }
        }
    }
}

fileprivate extension StoryListInteractorTests {
    final class MockNetworkSession : NetworkSessionProtocol {

        func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol? {
            let session = URLSessionMock()
            session.data = Stories.data
            let task = session.dataTask(with: request) { data, response, error in
                completionHandler(data,response,error)
            }
            task.resume()
            return task
        }

        func downloadTask(request: URLRequest, progressHandler: ProgressHandler?, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol? {
            return nil
        }

        func uploadTask(with request: URLRequest, from fileURL: URL, progressHandler: ProgressHandler?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol? {
            return nil
        }
    }
}
