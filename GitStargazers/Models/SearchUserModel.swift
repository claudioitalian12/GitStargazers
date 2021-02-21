//
//  SearchUserModel.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import Foundation

// MARK: - SearchUser

struct SearchUser: Decodable {
    
    // MARK: - internal property
    
    let items: Users
}
