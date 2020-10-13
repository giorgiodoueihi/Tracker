//
//  AppDelegate.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = PersistenceManager.shared
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceManager.shared.saveIfNecessary()
    }

    
    // MARK: - UISceneSession

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Tracker", sessionRole: connectingSceneSession.role)
    }
    
}
