//
//  AppDelegate.swift
//  ZombieConga
//
//  Created by Dimasno1 on 6/12/20.
//  Copyright © 2020 Dimasno1. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let controller = GameViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        return true
    }
}

