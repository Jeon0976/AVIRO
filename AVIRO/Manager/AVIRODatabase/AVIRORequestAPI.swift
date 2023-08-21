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
    static let placeSummary = "/prod/map/load/summary"
    static let placeInfoPath = "/prod/map/load/place"
    static let menuInfoPath = "/prod/map/load/menu"
    static let commentPath = "/prod/map/load/comment"
    static let checkPlace = "/prod/map/check/place"
    
    // MARK: Key
    static let longitude = "x"
    static let latitude = "y"
    static let wide = "wide"
    static let userId = "userId"
    static let time = "time"
    static let placeId = "placeId"
    
    static let title = "title"
    static let address = "address"
    static let x = "x"
    static let y = "y"
    
    // MARK: get Nerby Store
    mutating func getNerbyStore(userId: String,
                                longitude: String,
                                latitude: String,
                                wide: String,
                                time: String?
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.nerbyStore
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.userId, value: userId),
            URLQueryItem(name: AVIRORequestAPI.longitude, value: longitude),
            URLQueryItem(name: AVIRORequestAPI.latitude, value: latitude),
            URLQueryItem(name: AVIRORequestAPI.wide, value: wide),
            URLQueryItem(name: AVIRORequestAPI.time, value: time)
        ]
        
        return components
    }
    
    // MARK: Place Summary
    mutating func getPlaceSummary(placeId: String) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.placeSummary
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.placeId, value: placeId)
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

    // MARK: Check Place
    mutating func getCheckPlace(placeModel: PlaceCheckModel) -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.checkPlace
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.title, value: placeModel.title),
            URLQueryItem(name: AVIRORequestAPI.address, value: placeModel.address),
            URLQueryItem(name: AVIRORequestAPI.x, value: placeModel.x),
            URLQueryItem(name: AVIRORequestAPI.y, value: placeModel.y)
        ]
        
        return components
    }
}
