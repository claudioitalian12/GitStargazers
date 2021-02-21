//
//  AppDelegate.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setup()
        self.style()
        return true
    }
}

fileprivate extension AppDelegate {
    
    // MARK: - Setup
    
    private func setup() {
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        let rootViewController = SearchUserViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.window?.rootViewController = navigationController
    }
    
    // MARK: - Style
    
    private func style() {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }
}
