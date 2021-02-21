//
//  StargazersViewModel.swift
//  GitStargazers
//
//  Created by c331657 on 21/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class StargazersViewModel {

    // MARK: - internal property
    
    var users: Users = []
    var ownerName: String = ""
    var repositoryName: String = ""
    
    // MARK: - private property
    
    private var since: Int = 27
    private var page: Int = 0
    private var isDownloading: Bool = false
    private var isSearching: Bool = false
    
    // MARK: - typealias
    
    typealias CompletionHandler = (Result<Users?, NetworkError>) -> Void
    
   // MARK: - Init
    
    init(ownerName: String, repositoryName: String) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
    }
}

fileprivate extension StargazersViewModel {
    func setDownloadingStatus(status: Bool) {
        self.isDownloading = status
    }
}

extension StargazersViewModel {
    func refreshUsers(completion: @escaping CompletionHandler) {
        self.setDownloadingStatus(status: true)
        self.page = 0
        
        Networking<Users>.getStargazer(owner: self.ownerName,
                                       repo: repositoryName,
                                       page: self.page, completion: {[weak self] response in
                                        guard let self = self else { return }
                                        switch response {
                                        case let .success(users):
                                            guard let users = users else { return }
                                            self.users = users
                                            self.page += 1
                                            completion(.success(users))
                                        case let .failure(error):
                                            completion(.failure(error))
                                        }
                                        self.setDownloadingStatus(status: false)
        })
    }
    
    func getUsers(completion: @escaping CompletionHandler) {
        self.setDownloadingStatus(status: true)
        
        Networking<Users>.getStargazer(owner: self.ownerName,
                                       repo: repositoryName,
                                       page: self.page, completion: {[weak self] response in
                                        guard let self = self else { return }
                                        switch response {
                                        case let .success(users):
                                            guard let users = users else { return }
                                            self.users.append(contentsOf: users)
                                            self.page += 1
                                            completion(.success(users))
                                        case let .failure(error):
                                            completion(.failure(error))
                                        }
                                        self.setDownloadingStatus(status: false)
        })
    }
    
    func loadMoreUsers(index: Int,
                       completion: @escaping CompletionHandler) {
        
        if index == self.since * page && !self.isDownloading {
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
}
