//
//  NetworkManager.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/16/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

typealias ModelRequestCompletion = (ModelRequestResult<Decodable>) -> Void

enum ModelRequestResult<Decodable> {
    case success(Decodable?)
    case failure(Error?)
}

class NetworkManager {
    
    var session: URLSession!
    
    init() {
        session = URLSession.shared
    }
    
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?, responseModel: T.Type, completion: ModelRequestCompletion?) {
        guard let url = URL(string: endpoint) else {
            let error = NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Bad URL"])
            completion?(.failure(error))
            return
        }
        executeRequest(url: url, httpMethod: .GET, parameters: parameters, responseModel: responseModel, completion: completion)
    }
    
    func executeRequest<T: Decodable>(url: URL, httpMethod: HTTPMethod, parameters: [String: Any]?, data: Data? = nil, responseModel: T.Type,cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: ModelRequestCompletion?) {
        let request = generateRequest(url: url, httpMethod: HTTPMethod.GET, parameters: parameters, data: nil)
        let task = dataTask(request: request, responseModel: responseModel, completion: completion)
        task.resume()
    }
    
    func generateRequest(url: URL, httpMethod: HTTPMethod, parameters: [String: Any]?, data: Data?, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> URLRequest {
        var url = url
        if let parameters = parameters {
            url = URL(string: url.absoluteString + parameters.stringFromHttpParameters())!
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = cachePolicy
        if let data = data {
            request.httpBody = data
        }
        return request
    }
    
    func dataTask<T: Decodable>(request: URLRequest, responseModel: T.Type, completion: ModelRequestCompletion?) -> URLSessionDataTask {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let error = NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription])
                completion?(.failure(error))
            } else if let data = data {
                do {
                    let dataObject = try JSONDecoder().decode(responseModel, from: data)
                    completion?(.success(dataObject))
                } catch {
                    print("Network Decode error for \(responseModel): \(error.localizedDescription)")
                    completion?(.failure(error))
                }
            }
        }
        return task
    }
}
