//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = scene as? UIWindowScene else {
            return
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        PersistenceManager.shared.saveIfNecessary()
    }

}
