//
//  ApiRe.swift
//  TopStoriesTests
//
//  Created by Mozhgan on 9/7/22.
//

import Foundation
@testable import TopStories
import XCTest
final class APIRequestDispatcherTests : XCTestCase {
    private var subjectUnderTest : APIRequestDispatcher!
    
    override func setUp() {
        subjectUnderTest = .init(environment: APIEnvironment.production,
                                 networkSession: APINetworkSession())
    }
    
    override func tearDown() {
        subjectUnderTest = nil
    }
    
    func testApiRequest() {
        let expectation = XCTestExpectation(description: "revoking api")
        var response : Data = .init()
        _ = subjectUnderTest.execute(request: TopStoriesEndpoint.home) { result in
            guard case let .success(data) = result else {
                return
            }
            response = data
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(response.count > 0)
    }
}
