//
//  Protocol.swift
//  GitStargazers
//
//  Created by c331657 on 21/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

protocol ReusableCell {
    static var reusableIdentifier: String { get }
}

extension ReusableCell {
    static var reusableIdentifier: String {
        String(describing: Self.self)
    }
}
