//
//  TopStoryNetworkManager.swift
//  TopStories
//
//  Created by Mozhgan on 8/28/22.
//

import Foundation
import Combine
final class TopStoryNetworkManager : TopStoryNetworkManagerProtocol {
    
    private var  requestDispatcher : APIRequestDispatcher
    
    init(environment : EnvironmentProtocol,sessionConfiguration : URLSessionConfiguration) {
        requestDispatcher =  APIRequestDispatcher(environment: APIEnvironment.development,
                                                  networkSession: APINetworkSession(configuration: sessionConfiguration, delegateQueue:  OperationQueue()))
    }
    
    func home(completionHandler :@escaping (Result<Stories,APIError>) -> Void) {
        let homeOperation = APIOperation(.api(request: TopStoriesEndpoint.home))
        homeOperation.execute(in: requestDispatcher, completion: { operationResult in
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
    }
    
    func downloadImage(url: URL, completionHandler: (Result<URL, APIError>) -> Void) {
    }

}
