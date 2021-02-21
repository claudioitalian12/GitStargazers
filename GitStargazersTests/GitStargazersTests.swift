//
//  GitStargazersTests.swift
//  GitStargazersTests
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import XCTest
@testable import GitStargazers

class GitStargazersTests: XCTestCase {
    
    // MARK: - Networking Request
    
    func testValidGetUsers() {
        let promise = expectation(description: "Download users")
        
        Networking<Users>.getUsers(since: 0, page: 20, completion: {response in
            switch response {
            case .success:
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        })
        
        wait(for: [promise], timeout: 5)
    }
    
    func testValidGetRepository() {
        let promise = expectation(description: "Download repository")
        
        Networking<Repository>.getRepository(owner: "octocat", page: 1, completion: {response in
            switch response {
            case .success:
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        })
        
        wait(for: [promise], timeout: 5)
    }
    
    func testValidGetStargazer() {
        let promise = expectation(description: "Download stargazer")
        
        Networking<Users>.getStargazer(owner: "octocat", repo: "hello-world", page: 1, completion: {response in
            switch response {
            case .success:
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        })
        
        wait(for: [promise], timeout: 5)
    }
    
    func testValidGetSearchUser() {
        let promise = expectation(description: "Download search User")
        
        Networking<SearchUser>.getSearchUser(userName: "octocat", completion: {response in
            switch response {
            case .success:
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        })
        
        wait(for: [promise], timeout: 5)
    }
}
