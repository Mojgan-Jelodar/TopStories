//
//  File.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import Foundation
//swift
/// Class that handles the dispatch of requests to an environment with a given configuration.
final class APIRequestDispatcher: RequestDispatcherProtocol {
    
    /// The environment configuration.
    private var environment: EnvironmentProtocol
    
    /// The network session configuration.
    private var networkSession: NetworkSessionProtocol
    
    /// Required initializer.
    /// - Parameters:
    ///   - environment: Instance conforming to `EnvironmentProtocol` used to determine on which environment the requests will be executed.
    ///   - networkSession: Instance conforming to `NetworkSessionProtocol` used for executing requests with a specific configuration.
    required init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol) {
        self.environment = environment
        self.networkSession = networkSession
    }
    
    /// Executes a request.
    /// - Parameters:
    ///   - request: Instance conforming to `RequestProtocol`
    ///   - completion: Completion handler.
    func execute(request: RequestProtocol, completion: @escaping (Result<Data,APIError>) -> Void) -> URLSessionTask {
        var urlRequest = request.urlRequest(with: environment)!
        let encodedRequest = try? request.parameterEncoding.encode(urlRequest, with: request.parameters)
        urlRequest = encodedRequest != nil ? encodedRequest! : urlRequest
        environment.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })
        let task = networkSession.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
            guard let self = self,
                  let urlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            let result = self.verify(data: data, urlResponse: urlResponse, error: error)
            guard case let .success(response) = result else {
                guard case let .failure(err) = result else {
                    return
                }
                completion(.failure(err))
                return
            }
            // swiftlint:disable force_cast
            completion(.success(response as! Data))
            // swiftlint:enable force_cast
        })
        task.resume()
        return task
    }
    
    func download(request: URLRequest, progressHandler: ProgressHandler?, completion: @escaping (Result<URL, APIError>) -> Void) -> URLSessionTask {
        let task = networkSession.downloadTask(request: request, progressHandler: progressHandler) { [weak self]  fileUrl, urlResponse, error in
            guard let self = self,
                  let urlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            let result = self.verify(data: fileUrl, urlResponse: urlResponse, error: error)
            guard case let .success(url) = result else {
                guard case let .failure(err) = result else {
                    return
                }
                completion(.failure(err))
                return
            }
            // swiftlint:disable force_cast
            completion(.success(url as! URL))
            // swiftlint:enable force_cast
        }
        task.resume()
        return task
    }
    
    func upload(request: URLRequest, data: Data, progressHandler: ProgressHandler?, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionTask {
        let task = networkSession.downloadTask(request: request, progressHandler: progressHandler) { [weak self] _, urlResponse, error in
            guard let self = self,
                  let urlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            let result = self.verify(data: data, urlResponse: urlResponse, error: error)
            guard case let .success(response) = result else {
                guard case let .failure(err) = result else {
                    return
                }
                completion(.failure(err))
                return
            }
            // swiftlint:disable force_cast
            completion(.success(response as! Data))
            // swiftlint:enable force_cast
        }
        task.resume()
        return task
    }
}

fileprivate extension APIRequestDispatcher {
    /// Checks if the HTTP status code is valid and returns an error otherwise.
    /// - Parameters:
    ///   - data: The data or file  URL .
    ///   - urlResponse: The received  optional `URLResponse` instance.
    ///   - error: The received  optional `Error` instance.
    /// - Returns: A `Result` instance.
    private func verify(data: Any?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Any, APIError> {
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(APIError.noData)
            }
        case 400...499:
            return .failure(APIError.badRequest(error?.localizedDescription))
        case 500...599:
            return .failure(APIError.serverError(error?.localizedDescription))
        default:
            return .failure(APIError.unknown)
        }
    }
}
