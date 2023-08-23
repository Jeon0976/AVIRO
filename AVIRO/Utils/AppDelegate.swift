//
//  AppDelegate.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit
import AuthenticationServices

import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let keyUrl = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: keyUrl) as? [String: Any] else { return true }
                
        let key = (dictionary["NMFAuthManager_Authorization_Key"] as? String)!
        
        NMFAuthManager.shared().clientId = key
        sleep(1)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: App 종료 & 백그라운드 갈때 star data 서버에 저장
    func applicationWillResignActive(_ application: UIApplication) {
        let bookmarkManager = BookmarkFacadeManager()

        bookmarkManager.updateAllData()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let bookmarkManager = BookmarkFacadeManager()

        bookmarkManager.updateAllData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let bookmarkManager = BookmarkFacadeManager()

        bookmarkManager.updateAllData()
    }

}
