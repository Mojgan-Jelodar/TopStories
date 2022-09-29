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
                                                  networkSession: APINetworkSession(configuration: sessionConfiguration, delegateQueue:  queue))
    }
    
    func home(completionHandler :@escaping (Result<Stories,APIError>) -> Void) -> OperationProtocol {
        let homeOperation = APIOperation(.api(request: TopStoriesEndpoint.home),
                                         requestDispatcher: self.requestDispatcher)
        homeOperation.execute(completion: { operationResult in
            guard case let .data(data) = operationResult else {
                guard case let .error(error) = operationResult else {
                    return
                }
                completionHandler( Result.failure(error))
                return
            }
            do {
                // swiftlint:disable force_cast
                let stories = try Stories(data: data as! Data)
                // swiftlint:enable force_cast
                completionHandler(Result.success(stories))
            } catch let error {
                completionHandler(.failure(APIError.parseError(error.localizedDescription)))
            }
        })
        return homeOperation
    }
}
