//
//  AppDelegate.swift
//  TopStories
//
//  Created by Mozhgan on 8/27/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    
    let topStoryNetworkManager = TopStoryNetworkManager(environment: APIEnvironment.production, sessionConfiguration: .default)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        topStoryNetworkManager.home { result in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let failure):
                print(failure)
            }
        }
        
        return true
    }
}
