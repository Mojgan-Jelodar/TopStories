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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.setRootWireframe(StoryListWireframe())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
