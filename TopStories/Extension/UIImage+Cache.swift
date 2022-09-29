//
//  ImageCacher.swift
//  TopStories
//
//  Created by Mozhgan on 9/29/22.
//

import Foundation
import UIKit

enum ImageError : Error {
    case invalidUrl(String)
    case invalidResponse(URLResponse?,Error?)
}
extension UIImage {
    static func loadImageFrom(urlString : String,
                              completionHandler : @escaping (Result<UIImage,ImageError>) -> Void) {
        let cache = URLCache.shared
        let session = URLSession.shared
        if let url = URL(string: urlString) {
            let request : URLRequest = .init(url: url)
            if let data = cache.cachedResponse(for: request)?.data,
               let image = UIImage(data: data) {
                completionHandler(.success(image))
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    let task = session.dataTask(with: request) { data, response, error in
                        DispatchQueue.main.async {
                            if let data = data,
                               let response = response as? HTTPURLResponse,
                               response.statusCode >= 200 && response.statusCode < 300,
                               let image = UIImage(data: data) {
                                cache.cachedResponse(for: request)
                                completionHandler(.success(image))
                            } else {
                                completionHandler(.failure(.invalidResponse(response, error)))
                            }
                        }
                    }
                    task.resume()
                }
            }
        } else {
            completionHandler(.failure(ImageError.invalidUrl(urlString)))
        }
    }
}
