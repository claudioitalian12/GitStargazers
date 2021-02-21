//
//  RepositoryViewModel.swift
//  GitStargazers
//
//  Created by c331657 on 20/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class RepositoryViewModel {
    
    // MARK: - internal property
    
    var repository: Repository = []
    var owner: String = ""
    var usersIsEmpty: Bool {
        return repository.count < 1
    }
    
    // MARK: - private property
    
    private var page: Int = 1
    private var displayRepositoryIndex: Int = 27
    private var isDownloading: Bool = false
    
    // MARK: - typealias
    
    typealias CompletionHandler = (Result<Repository?, NetworkError>) -> Void
    
    // MARK: - Init
    
    init(owner: String) {
        self.owner = owner
    }
}

fileprivate extension RepositoryViewModel {
    func setDownloadingStatus(status: Bool) {
        self.isDownloading = status
    }
}

extension RepositoryViewModel {
    func loadRepository(completion: @escaping CompletionHandler) {
        self.setDownloadingStatus(status: true)
        
        Networking<Repository>.getRepository(owner: self.owner,
                                             page: self.page,
                                             completion: {[weak self] response in
                                                guard let self = self else { return }
                                                switch response {
                                                case .success(let repository):
                                                    guard let repository = repository else {
                                                        return
                                                    }
                                                    self.repository.append(contentsOf: repository)
                                                    self.page += 1
                                                    completion(.success(repository))
                                                case .failure(let error):
                                                    completion(.failure(error))
                                                }
                                                self.setDownloadingStatus(status: false)
        })
    }
    
    func loadMoreRepository(index: Int,
                            completion: @escaping CompletionHandler) {
        if index == displayRepositoryIndex * (self.page - 1) && !self.isDownloading {
            self.loadRepository { response in
                switch response {
                case let .success(repository):
                    guard let repository = repository else {
                        return
                    }
                    completion(.success(repository))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
