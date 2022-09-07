//
//  StoryListInteractor.swift
//  TopStories
//
//  Created by Mozhgan on 8/30/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class StoryListInteractor : StoryListInteractorInterface {
    private let worker: TopStoryNetworkManagerProtocol
    private var operations : [OperationProtocol] = []
    private var cache: NSCache<NSString, NSURL> = .init()
    
    deinit {
        operations.forEach({$0.cancel()})
    }
    
    init(worker: TopStoryNetworkManagerProtocol) {
        self.worker = worker
    }
    
    func fetch(result: @escaping ((Result<Stories, APIError>) -> Void)) {
        operations.append(worker.home(completionHandler: { completionHandler in
            DispatchQueue.main.async {
                switch completionHandler {
                case .success(let value):
                    result(.success(value))
                case .failure(let error):
                    result(.failure(error))
                }
            }
        })!)
    }
}
