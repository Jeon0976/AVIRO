//
//  AppDelegate.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit
import AuthenticationServices

import NMapsMap
import AmplitudeSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var amplitude: Amplitude?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        self.setNaverMapAPI()
        self.setAmplitude()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func setNaverMapAPI() {
        guard let keyUrl = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: keyUrl) as? [String: Any] else { return }
                
        let key = (dictionary["NMFAuthManager_Authorization_Key"] as? String)!
        
        NMFAuthManager.shared().clientId = key
    }
    
    private func setAmplitude() {
        guard let keyUrl = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: keyUrl) as? [String: Any] else { return }
        
        let key = (dictionary["Amplitude_Key"] as? String)!
        
        amplitude = Amplitude(configuration: Configuration(apiKey: key))
     }
}
