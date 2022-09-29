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
    func testSuccessedFetch() {
        let expectation = XCTestExpectation(description: "revoking api")
        networkManager.result = .success(.mock)
        var stories : Stories?
        subjectUnderTest.fetch { result in
            switch result {
            case .success(let value):
                stories = value
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed loading the data : \(error.localizedDescription)")
            }
            
        }
        wait(for: [expectation], timeout: 1)
        XCTAssert(stories == Stories.mock)
    }
    
    func testFailedFetch() {
        let expectation = XCTestExpectation(description: "revoking api")
        let error = APIError.invalidResponse
        var apiError : APIError?
        networkManager.result = .failure(error)
        subjectUnderTest.fetch { result in
            switch result {
            case .success:
                XCTFail("Unexpected result...")
            case .failure(let error):
                apiError = error
                expectation.fulfill()
                
            }
            
        }
        wait(for: [expectation], timeout: 1)
        XCTAssert(error == apiError)
    }
}
