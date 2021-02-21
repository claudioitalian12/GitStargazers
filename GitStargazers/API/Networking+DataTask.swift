//
//  Networking+DataTask.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

extension Networking {
    /**
     This method create a task.
     
     Default response for githubapi have Status: 200 OK
     
     - parameter request: the api request.
     - parameter completion: the model? and the error.
     - returns: dataTask.
     
     # Notes: #
     1. Parameters must be **URLRequest** type
     2. Handle return parameters.
     
     # Example #
     ```
     Networking<Decodable>.dataTask(with: request) { response in }
     ```
     */
    static func dataTask(with request: URLRequest,
                         completionHandler completion: @escaping CompletionHandler) -> URLSessionDataTask {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = error as? URLError {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(Model.self, from: data)
                        completion(.success(model))
                    } catch {
                        completion(.failure(.jsonParsingError))
                    }
                } else {
                    completion(.failure(.requestFailed))
                }
            } else {
                completion(.failure(.requestStatusError))
            }
        }
        return task
    }
    
    /**
     This method invoke task.
     
     - parameter request: the api request.
     - parameter completion: the model? and the error.
     - returns: void.
     
     # Notes: #
     1. Parameters must be **URLRequest** type
     2. Handle return parameters.
     
     # Example #
     ```
     Networking<Decodable>.dataTaskRequest(with: request) { response in }
     ```
     */
    static func dataTaskRequest(request: URLRequest,
                                completion: @escaping CompletionHandler) {
        let sessionDataTask = dataTask(with: request) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let response):
                    guard let response = response else { return }
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        sessionDataTask.resume()
    }
}
