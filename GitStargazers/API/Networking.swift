//
//  Networking.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import Foundation

/// Networking
struct Networking<Model: Decodable> {
    typealias CompletionHandler = (Result<Model?, NetworkError>) -> Void
    
    /**
     This method get a list of users, in the order that they signed up on GitHub.
     This list includes personal user accounts and organization accounts..
     
     - parameter since: the starting user id.
     - parameter page: the number of users to be taken.
     - parameter completion: the model? and the error.
     - returns: void.
     
     # Notes: #
     1. Parameters must be **Int** type
     2. Handle return parameters.
     
     # Example #
     ```
     Networking<Users>.getUsers(page: 1, completion: {response in
     print(response)
     })
     ```
     */
    static func getUsers(since: Int,
                         page: Int,
                         completion: @escaping CompletionHandler) {
        guard let request = GitEndpoint.users(since: since, page: page).request else {
                completion(.failure(.requestError))
                return
        }
        
        self.dataTaskRequest(request: request) { result in
            completion(result)
        }
    }
    
    /**
     This method get a list of repository from owner.
     
     - parameter owner: the owner name.
     - parameter page: the number of repository to be taken.
     - parameter completion: the model? and the error.
     - returns: void.
     
     # Notes: #
     1. Parameters must be **String** type and **Int** type
     2. Handle return parameters.
     
     # Example #
     ```
     Networking<Repository>.getRepository(owner: "octocat", page: 1, completion: {response in
     print(response)
     })
     ```
     */
    static func getRepository(owner: String,
                              page: Int,
                              completion: @escaping CompletionHandler) {
        guard let request = GitEndpoint.repository(owner: owner, page: page).request else {
                completion(.failure(.requestError))
                return
        }
        
        self.dataTaskRequest(request: request) { result in
            completion(result)
        }
    }
    
    /**
     This method get a list of stargazer for a specific repo.
     
     - parameter owner: the owner name.
     - parameter repo: the repository name.
     - parameter completion: the model? and the error.
     - returns: void.
     
     # Notes: #
     1. Parameters must be **String** type
     2. Handle return parameters.
     
     # Example #
     ```
     Networking<Users>.getStargazer(owner: "octocat", page: 1, completion: {response in
     print(response)
     })
     ```
     */
    static func getStargazer(owner: String,
                             repo: String,
                             page: Int,
                             completion: @escaping CompletionHandler) {
        guard let request = GitEndpoint.stargazer(owner: owner, repo: repo, page: page).request else {
                completion(.failure(.requestError))
                return
        }
        
        self.dataTaskRequest(request: request) { result in
            completion(result)
        }
    }
    
    /**
     This method get a list of user with the search name.
     
     Rate limit:
     The Search API has a custom rate limit. For requests using Basic Authentication, OAuth, or client ID and secret,
     you can make up to 30 requests per minute. For unauthenticated requests,
     the rate limit allows you to make up to 10 requests per minute.
     See the rate limit documentation for details on determining your current rate limit status.
     
     - parameter userName: the owner name.
     - parameter completion: the model? and the error.
     - returns: void.
     
     # Notes: #
     1. Parameters must be **String** type
     2. Handle return parameters.
     
     # Example #
     ```
     Networking<SearchUser>.getSearchUser(userName: "octocat", page: 1, completion: {response in
     print(response)
     })
     ```
     */
    static func getSearchUser(userName: String,
                              completion: @escaping CompletionHandler) {
        guard let request = GitEndpoint.searchUser(userName: userName).request
            else {
                completion(.failure(.requestError))
                return
        }
        
        self.dataTaskRequest(request: request) { result in
            completion(result)
        }
    }
}
