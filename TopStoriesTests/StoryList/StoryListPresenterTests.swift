//
//  StoryListPresenterTests.swift
//  TopStoriesTests
//
//  Created by Mozhgan on 9/6/22.
//

@testable import TopStories
import XCTest
final class StoryListPresenterTests : XCTestCase {
    private var subjectUnderTest : StoryListPresenter!
    private var interactor : MockStoryListInteractor!
    private var view : MockStoryListView!
    private var router : MockStoryListWireframe!
    private var formatter : MockStoryListFormatter!
    private var topStoryNetworkManager : MockTopStoryNetworkManager!
    
    override func setUp() {
        topStoryNetworkManager = MockTopStoryNetworkManager()
        interactor =  MockStoryListInteractor(worker: topStoryNetworkManager)
        view = MockStoryListView()
        router = MockStoryListWireframe()
        formatter = MockStoryListFormatter()
        subjectUnderTest = .init(view: view,
                                 formatter: formatter,
                                 interactor: interactor,
                                 wireframe: router)
    }
    
    override func tearDown() {
        interactor =  nil
        view = nil
        router = nil
        formatter = nil
        subjectUnderTest = nil
    }
    
    func testViewDidLoad() {
        topStoryNetworkManager.result = .success(.mock)
        self.subjectUnderTest.pullToRefresh()
        guard case let .list(data) = self.view.viewState else {
          return
        }
        XCTAssert(data == Stories.mock.results?.map({.init(story: $0)}))
    }
    func testDidSelectItem() {
        let story = Stories.mock.results!.first!
        self.subjectUnderTest.didSelect(viewModel: .init(story: story))
        XCTAssert(router.desination == StoryListDesination.detail(item: story))
    }
    
    func testErrorOccurred() {
        let error = APIError.invalidResponse
        topStoryNetworkManager.result = .failure(error)
        subjectUnderTest.pullToRefresh()
        XCTAssert(router.messageIsPresented)
    }
}
fileprivate extension StoryListPresenterTests {
    final class MockStoryListInteractor : StoryListInteractorInterface {
        let topStoryNetworkManager : TopStoryNetworkManagerProtocol
        init(worker: TopStoryNetworkManagerProtocol) {
            self.topStoryNetworkManager = worker
        }
        
        func fetch(result: @escaping ((Result<Stories, APIError>) -> Void)) {
            _ = topStoryNetworkManager.home(completionHandler: result)
        }
    }
}
fileprivate extension StoryListPresenterTests {
    final class MockStoryListView : StoryListViewInterface {
        private(set) var isLoading : Bool = false
        private(set) var viewState: StoryListViewController.ViewState!
        func startLoading() {
            isLoading = true
        }
        
        func stopLoading() {
            isLoading = false
        }
        
        func show(viewState: StoryListViewController.ViewState) {
            self.viewState = viewState
        }
    }
}
fileprivate extension StoryListPresenterTests {
    final class MockStoryListWireframe : StoryListWireframeInterface {
        private(set) var messageIsPresented : Bool = false
        private(set) var desination: StoryListDesination!
        
        func present(message: String) {
            self.messageIsPresented = true
        }
        
        func routeTo(desination: StoryListDesination) {
            self.desination = desination
        }
    }
}
fileprivate extension StoryListPresenterTests {
    final class MockStoryListFormatter : StoryListFormatterInterface {
        func format(stories: Stories) -> StoryListViewController.ViewState {
            guard let results = stories.results,!results.isEmpty else {
                return .emptyState
            }
            return .list(results.map({StoryCellViewModel.init(story: $0)}))
        }
    }
}
