//
//  AVIRORequestAPI.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct AVIRORequestAPI {
    static let scheme = "https"
    
    lazy var host: String = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let host = dict["AVIROHost"] as? String else {
            fatalError("failed to load AVIRO API.plist ")
        }
        return host
    }()
    
    // MARK: Path
    static let allDataPath = "/prod/map"
    
    // MARK: Key
    static let longitude = "x"
    static let latitude = "y"
    static let wide = "wide"
    
    // MARK: response All Data
    mutating func responseAllData(longitude: String,
                                  latitude: String,
                                  wide: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.allDataPath
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.longitude, value: longitude),
            URLQueryItem(name: AVIRORequestAPI.latitude, value: latitude),
            URLQueryItem(name: AVIRORequestAPI.wide, value: wide)
        ]
        
        return components
    }
    
}
