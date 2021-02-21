//
//  GitEndpoint.swift
//  GitEndpoint
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import Foundation

enum GitEndpoint {
    case users(since: Int, page: Int)
    case repository(owner: String, page: Int)
    case stargazer(owner: String, repo: String, page: Int)
    case searchUser(userName: String)
}

extension GitEndpoint: Endpoint {
    
    // MARK: - internal property
    
    var base: String {
        switch self {
        case .users, .repository, .stargazer, .searchUser:
            return "https://api.github.com"
        }
    }
    var path: String {
        switch self {
        case .users: return "/users"
        case let .repository(owner, _):
            return "/users/\(owner)/repos"
        case let .stargazer(owner, repo, _):
            return "/repos/\(owner)/\(repo)/stargazers"
        case .searchUser:
            return "/search/users"
        }
    }
    var queryItems: [URLQueryItem] {
        switch self {
        case let .users(since, page):
            return [
                URLQueryItem(name: "since", value: "\(since)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case let .repository(_, page):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case let .stargazer(_, _, page):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case let .searchUser(userName):
            return [
                URLQueryItem(name: "q", value: userName)
            ]
        }
    }
}
