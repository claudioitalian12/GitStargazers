//
//  Endpoint.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    // MARK: - internal property
    
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    
    // MARK: - internal property
    
    var urlComponents: URLComponents? {
        var components = URLComponents(string: base)
        components?.path = path
        components?.queryItems = queryItems
        return components
    }
    var request: URLRequest? {
        guard let url = urlComponents?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    var url: URL? {
        urlComponents?.url
    }
}
