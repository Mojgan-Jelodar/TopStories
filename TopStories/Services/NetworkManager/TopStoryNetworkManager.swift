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
    private var tasks : [URLSessionTask] = []
    
    deinit {
        tasks.forEach({$0.cancel()})
    }
    init(environment : EnvironmentProtocol,
         sessionConfiguration : URLSessionConfiguration,
         queue : OperationQueue) {
        requestDispatcher =  APIRequestDispatcher(environment: APIEnvironment.development,
                                                  networkSession: APINetworkSession(configuration: sessionConfiguration, delegateQueue:  queue))
    }
    
    func home(completionHandler :@escaping (Result<Stories,APIError>) -> Void) {
        let task = requestDispatcher.execute(request: TopStoriesEndpoint.home) { result in
            switch result {
            case .success(let data) :
                do {
                    let stories = try Stories(data: data)
                    completionHandler(Result.success(stories))
                } catch let error {
                    completionHandler(.failure(APIError.parseError(error.localizedDescription)))
                }
            case .failure(let error) :
                completionHandler( Result.failure(error))
            }
        }
        tasks.append(task)
    }
}
