//
//  AVIROPostAPI.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct AVIROPostAPI {
    
    static let scheme = "https"
    
    lazy var host: String = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let host = dict["AVIROHost"] as? String else {
            fatalError("failed to load AVIRO API.plist ")
        }
        return host
    }()
    
    static let placeInrollPath = "/prod/map/add/place"

    // MARK: Place Inroll 
    mutating func placeInroll() -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.placeInrollPath
        
        return components
    }
}
