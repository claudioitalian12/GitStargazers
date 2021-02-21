//
//  UserModel.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import Foundation

// MARK: - User

typealias Users = [User]

struct User: Decodable {
    
    // MARK: - internal property
    
    let userName: String
    let avatarURL: String
    let type: String
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatarURL = "avatar_url"
        case type
    }
}
