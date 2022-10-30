//
//  ImageCacher.swift
//  TopStories
//
//  Created by Mozhgan on 9/29/22.
//

import Foundation
import UIKit

import Foundation
import UIKit
typealias DownloadResult = (Result<ImageLoadingResult,ImageError>) -> Void
enum ImageError : Error {
    case invalidUrl(String)
    case invalidResponse(URLResponse?,Error?)
}
/// Represents a success result of an image downloading progress.
public struct ImageLoadingResult {
    
    /// The downloaded image.
    public let image: UIImage?
    
    /// Original URL of the image request.
    public let url: URL?
}

fileprivate class ImageDownloadTask: URLProtocol {
    
    var cancelledOrComplete: Bool = false
    private var block: DispatchWorkItem!
    private static let queue = DispatchQueue(label: "com.apple.imageLoaderURLProtocol",
                                             attributes: .concurrent)
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    class override func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return false
    }
    
    final override func startLoading() {
        guard let reqURL = request.url, let urlClient = client else {
            return
        }
        
        block = DispatchWorkItem(qos: .background,block: {
            if self.cancelledOrComplete == false {
                if let data = try? Data(contentsOf: reqURL) {
                    urlClient.urlProtocol(self, didLoad: data)
                    urlClient.urlProtocolDidFinishLoading(self)
                }
            }
            self.cancelledOrComplete = true
        })
        ImageDownloadTask.queue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 500 * NSEC_PER_MSEC), execute: block)
    }
    
    final override func stopLoading() {
        ImageDownloadTask.queue.async {
            if self.cancelledOrComplete == false, let cancelBlock = self.block {
                cancelBlock.cancel()
                self.cancelledOrComplete = true
            }
        }
    }
    
    static var session : URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [ImageDownloadTask.classForCoder()]
        config.httpMaximumConnectionsPerHost = 4
        return  URLSession(configuration: config)
    }
    
}


final class ImageLoader {
    private var cachedImages : NSCache<NSURL,UIImage> = .init()
    private var runningRequests = [UUID: URLSessionDataTask]()
    private let concurrentQueue : DispatchQueue = .init(label: "com.app.ImageLoader",attributes: .concurrent)
    
    private final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }

    func loadImage(_ url: URL, _ completion: @escaping DownloadResult) -> UUID? {
        
        let request = URLRequest(url: url)
        // 1
        if let cachedImage = self.image(url: url as NSURL) {
            completion(.success(.init(image: cachedImage, url: url)))
            return nil
        }
        // 2
        let uuid = UUID()
        
        let task = ImageDownloadTask.session.dataTask(with: request) { [weak self] data, response, error in
            // 3
            defer {
                self?.concurrentQueue.async(flags: .barrier, execute: {
                    self?.runningRequests.removeValue(forKey: uuid)
                })
            }
            // 4
            if let data = data, let image = UIImage(data: data) {
                self?.concurrentQueue.async(flags: .barrier, execute: {
                    self?.cachedImages.setObject(image, forKey: url as NSURL)
                })
                
                completion(.success(.init(image: image, url: url)))
                return
            }
            
            // 5
            guard let error = error else {
                // without an image or an error, we'll just ignore this for now
                // you could add your own special error cases for this scenario
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(.invalidResponse(response, error)))
                return
            }
            
            // the request was cancelled, no need to call the callback
        }
        task.resume()
        
        // 6
        self.runningRequests[uuid] = task
        return uuid
        
        
    }
    
    func cancelLoad(_ uuid: UUID) {
        self.concurrentQueue.sync {[weak self] in
            self?.runningRequests[uuid]?.cancel()
            self?.concurrentQueue.async(flags: .barrier, execute: {
                self?.runningRequests.removeValue(forKey: uuid)
            })
        }
    }
    
}

final class UIImageLoader {
    static let loader = UIImageLoader()
    
    private let concurrentQueue : DispatchQueue = .init(label: "com.app.UIImageLoader",attributes: .concurrent)
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ url: URL, for imageView: UIImageView,completion: DownloadResult?) {
        // 1
        let token = imageLoader.loadImage(url) { [weak self] result in
            // 2
            defer {
                self?.concurrentQueue.async(flags: .barrier, execute: {
                    self?.uuidMap.removeValue(forKey: imageView)
                })
            }
            
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    imageView.image = value.image
                    completion?(.success(value))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }
        
        // 4
        if let token = token {
            self.concurrentQueue.async(flags: .barrier, execute: { [weak self] in
                self?.uuidMap[imageView] = token
            })
        }
    }
    
    func cancel(for imageView: UIImageView) {
        self.concurrentQueue.sync {[weak self] in
            if let uuid = uuidMap[imageView] {
                self?.concurrentQueue.async(flags: .barrier, execute: {
                    self?.imageLoader.cancelLoad(uuid)
                    self?.uuidMap.removeValue(forKey: imageView)
                })
            }
        }
    }
}

//MARK: - add loading image into UIImageview
extension UIImageView {
    func loadImage(at url: String?,placeHolder : UIImage? = nil,completion: DownloadResult? = nil) {
        self.lock()
        self.image = placeHolder ?? UIImage()
        guard let path = url,let url = URL(string: path) else {
            return
        }
        UIImageLoader.loader.load(url, for: self) { [weak self] result in
            self?.unlock()
            switch result {
            case .success(let value):
                completion?(.success(value))
            case .failure(let error):
                self?.image = placeHolder
                completion?(.failure(error))
            }
        }
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
