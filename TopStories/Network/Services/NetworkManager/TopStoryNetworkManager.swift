//
//  TopStoryNetworkManager.swift
//  TopStories
//
//  Created by Mozhgan on 8/28/22.
//

import Foundation
import Combine
final class TopStoryNetworkManager : TopStoryNetworkManagerProtocol {
    
    private var requestDispatcher : APIRequestDispatcher
    init(environment : EnvironmentProtocol,
         sessionConfiguration : URLSessionConfiguration,
         queue : OperationQueue) {
        requestDispatcher =  APIRequestDispatcher(environment: APIEnvironment.development,
                                                  networkSession: APINetworkSession(session: .init(configuration: .default, delegate: nil, delegateQueue: queue)))
    }
    
    func home(completionHandler :@escaping (Result<Stories,APIError>) -> Void) -> OperationProtocol? {
        let homeOperation = APIOperation(TopStoriesEndpoint.home)
        homeOperation.execute(in: requestDispatcher, completion: { [weak self] result in
            guard case let .success(data) = result else {
                guard case let .failure(error) = result else {
                    return
                }
                completionHandler( Result.failure(error))
                return
            }
            self?.map(data: data, completionHandler: completionHandler)
        })
        return homeOperation
    }
    
    private func map(data : Data,completionHandler :@escaping (Result<Stories,APIError>) -> Void) {
        do {
            let stories = try Stories(data: data)
            completionHandler(Result.success(stories))
        } catch let error {
            completionHandler(.failure(APIError.parseError(error.localizedDescription)))
        }
    }
}
