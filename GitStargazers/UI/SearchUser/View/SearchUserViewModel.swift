//
//  SearchUserViewModel.swift
//  GitStargazers
//
//  Created by c331657 on 20/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class SearchUserViewModel {
    
    // MARK: - internal property
    
    var users: Users = []
    
    // MARK: - private property
    
    private var since: Int = 0
    private var page: Int = 20
    private var isDownloading: Bool = false
    private var isSearching: Bool = false
    
    // MARK: - typealias
    
    typealias CompletionHandler = (Result<Users?, NetworkError>) -> Void
}

fileprivate extension SearchUserViewModel {
    func setDownloadingStatus(status: Bool) {
        self.isDownloading = status
    }
}

extension SearchUserViewModel {
    func refreshUsers(completion: @escaping CompletionHandler) {
        self.setDownloadingStatus(status: true)
        self.since = 0
        self.page = 20
        
        Networking<Users>.getUsers(since: self.since,
                                   page: self.page,
                                   completion: {[weak self] response in
                                    guard let self = self else { return }
                                    switch response {
                                    case let .success(users):
                                        guard let users = users else { return }
                                        self.users = users
                                        self.since += 30
                                        completion(.success(users))
                                    case let .failure(error):
                                        completion(.failure(error))
                                    }
                                    self.setDownloadingStatus(status: false)
        })
    }
    
    func getUsers(completion: @escaping CompletionHandler) {
        self.setDownloadingStatus(status: true)
        
        Networking<Users>.getUsers(since: self.since + 1,
                                   page: page,
                                   completion: {[weak self] response in
                                    guard let self = self else { return }
                                    switch response {
                                    case let .success(users):
                                        guard let users = users else { return }
                                        self.users.append(contentsOf: users)
                                        self.since += 30
                                        completion(.success(users))
                                    case let .failure(error):
                                        completion(.failure(error))
                                    }
                                    self.setDownloadingStatus(status: false)
        })
    }
    
    func loadMoreUsers(index: Int,
                       completion: @escaping CompletionHandler) {
        
        if index == self.since - 3 && !self.isDownloading && !self.isSearching {
            self.getUsers { response in
                switch response {
                case let .success(users):
                    guard let users = users else { return }
                    completion(.success(users))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadSearchUser(searchUserName: String,
                        completion: @escaping CompletionHandler) {
        Networking<SearchUser>.getSearchUser(userName: searchUserName,
                                             completion: {response in
                                                switch response {
                                                case let .success(searchResult):
                                                    guard let searchResult = searchResult else { return }
                                                    self.users = searchResult.items
                                                    completion(.success(searchResult.items))
                                                case let .failure(error):
                                                    completion(.failure(error))
                                                }
        })
    }
    
    func setSearchingStatus(status: Bool) {
        self.isSearching = status
    }
}
