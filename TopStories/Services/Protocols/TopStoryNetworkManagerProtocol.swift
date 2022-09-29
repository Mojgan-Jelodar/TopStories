//
//  TopStoryNetworkManager.swift
//  TopStories
//
//  Created by Mozhgan on 8/28/22.
//

import Foundation

protocol TopStoryNetworkManagerProtocol {
    func home(completionHandler :@escaping (Result<Stories,APIError>) -> Void) -> OperationProtocol
}
