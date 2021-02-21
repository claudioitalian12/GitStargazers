//
//  RepositoryModel.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import Foundation

// MARK: - User

typealias Repository = [RepositoryElement]

struct RepositoryElement: Decodable {
    
    // MARK: - internal property
    let name: String
    let stargazersCount: Int
    
    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case name
        case stargazersCount = "stargazers_count"
    }
}
