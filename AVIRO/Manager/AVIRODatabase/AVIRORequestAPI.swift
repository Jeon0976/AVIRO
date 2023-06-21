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
    static let nerbyStore = "/prod/map"
    static let placeInfoPath = "/prod/map/load/place"
    static let menuInfoPath = "/prod/map/load/menu"
    static let commentPath = "/prod/map/load/comment"
    
    // MARK: Key
    static let longitude = "x"
    static let latitude = "y"
    static let wide = "wide"
    static let placeId = "placeId"

    // MARK: get Nerby Store
    mutating func getNerbyStore(longitude: String,
                                  latitude: String,
                                  wide: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.nerbyStore
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.longitude, value: longitude),
            URLQueryItem(name: AVIRORequestAPI.latitude, value: latitude),
            URLQueryItem(name: AVIRORequestAPI.wide, value: wide)
        ]
        
        return components
    }
    
    // MARK: place Info
    mutating func getPlaceInfo(placeId: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.placeInfoPath
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.placeId, value: placeId)
        ]
        
        return components
    }
    
    // MARK: Menu Info
    mutating func getMenuInfo(placeId: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.menuInfoPath
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.placeId, value: placeId)
        ]
        
        return components
    }

    
    // MARK: Comment Info
    mutating func getCommentInfo(placeId: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.commentPath
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.placeId, value: placeId)
        ]
        
        return components
    }

}
