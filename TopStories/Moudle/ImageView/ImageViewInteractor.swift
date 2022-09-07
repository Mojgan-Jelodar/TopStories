//
//  ImageViewInteractor.swift
//  TopStories
//
//  Created by Mozhgan on 9/3/22.
//

import Foundation
final class ImageViewInteractor : ImageViewInteractorInterface {
    
    deinit {
        task?.cancel()
    }
    private var task : URLSessionDataTaskProtocol?
    private var cache: NSCache<NSString, NSData> = .init()
    private let networkSession: APINetworkSession
    
    init(networkSession: APINetworkSession) {
        self.networkSession = networkSession
    }
    
    func download(path: String,completionHandler : @escaping (Result<Data,APIError>) -> Void) {
        if let url = URL(string: path) {
            if let value = cache.object(forKey: path as NSString) {
                completionHandler(.success(value as Data))
            } else {
                self.loadFromNetwork(url: url, completionHandler: completionHandler)
            }
        } else {
            completionHandler(.failure(.badRequest(path)))
        }
    }
    private func loadFromNetwork(url: URL,completionHandler : @escaping (Result<Data,APIError>) -> Void) {
        task = networkSession.dataTask(with: .init(url: url)) {[weak self] data, _, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(.failure(.serverError(error?.localizedDescription)))
                    return
                }
                guard let data = data,data.count > 0 else {
                    completionHandler(.failure(.noData))
                    return
                }
                self?.cache.setObject(data as NSData, forKey: url.path as NSString)
                completionHandler(.success(data))
            }
        }
        task?.resume()
    }
}
