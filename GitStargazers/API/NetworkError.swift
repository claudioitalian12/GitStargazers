//
//  NetworkError.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import Foundation

// MARK: - Error

enum NetworkError: String, Error {
    case badURL = "Error URL"
    case requestError = "Request Error"
    case requestFailed = "Request Failed"
    case requestStatusError = "Request status is not 200, we remind you that the github API has a recall limit, try again in a few minutes."
    case jsonParsingError = "JSON Parsing Error"
    case notConnect = "Connection not working"
    case alertError = "Unexpected problem"
    case maxNumberOfSearch = "The Search API has a custom rate limit, you to make up to 10 requests per minute."
}
