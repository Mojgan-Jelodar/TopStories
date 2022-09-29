//
//  StoryMock.swift
//  TopStoriesTests
//
//  Created by Mozhgan on 9/6/22.
//

import Foundation
@testable import TopStories
extension Stories {
    // swiftlint:disable force_try
    static let mock = try! Stories(data: Stories.data)
    static let data = try! Data(contentsOf: Bundle.testBundle.url(forResource: "Mock", withExtension: ".json")!)
}
fileprivate extension Bundle {
    static let testBundle = Bundle(for: StoryListInteractorTests.self)
}
