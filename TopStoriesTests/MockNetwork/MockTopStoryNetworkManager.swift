//
//  MockTopStoryNetworkManager.swift
//  TopStoriesTests
//
//  Created by Mozhgan on 9/29/22.
//

import Foundation
@testable import TopStories

final class MockTopStoryNetworkManager : TopStoryNetworkManagerProtocol {
    var result : Result<TopStories.Stories, TopStories.APIError>!
    func home(completionHandler: @escaping (Result<TopStories.Stories, TopStories.APIError>) -> Void) {
        completionHandler(result)
    }
}
