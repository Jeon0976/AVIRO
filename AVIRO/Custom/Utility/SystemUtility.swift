//
//  System.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/10/17.
//

import UIKit

struct SystemUtility {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(APP.appId.rawValue)"
    
    func latestVersion() -> String? {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(APP.appId.rawValue)&t=\(Date().timeIntervalSince1970)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
              ) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        
        return appStoreVersion
    }
    
    func openAppStore() {
        guard let url = URL(string: SystemUtility.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
