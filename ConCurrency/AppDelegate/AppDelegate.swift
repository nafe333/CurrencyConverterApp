//
//  AppDelegate.swift
//  ConCurrency
//
//  Created by Nafea Elkassas on 23/08/2023.
//

import UIKit
import DropDown
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared().isEnabled = true

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ConcurrencyViewController()
        window?.makeKeyAndVisible()


        return true
    }
}

