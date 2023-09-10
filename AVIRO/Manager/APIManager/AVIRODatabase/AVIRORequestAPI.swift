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
    static let getNerbyStorePath = "/prod/map"
    static let getBookmarkPath = "/prod/map/load/bookmark"
    
    static let checkPlacePath = "/prod/map/check/place"
    static let checkPlaceReport = "/prod/map/check/place/report"
    
    static let placeSummaryPath = "/prod/map/load/summary"
    static let placeInfoPath = "/prod/map/load/place"
    static let menuInfoPath = "/prod/map/load/menu"
    static let commentPath = "/prod/map/load/comment"
    static let operationHourPath = "/prod/map/load/timetable"
        
    // MARK: Key
    static let userId = "userId"
    
    static let longitude = "x"
    static let latitude = "y"
    static let wide = "wide"
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
        components.path = AVIRORequestAPI.getNerbyStorePath
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.userId, value: userId),
            URLQueryItem(name: AVIRORequestAPI.longitude, value: longitude),
            URLQueryItem(name: AVIRORequestAPI.latitude, value: latitude),
            URLQueryItem(name: AVIRORequestAPI.wide, value: wide),
            URLQueryItem(name: AVIRORequestAPI.time, value: time)
        ]
        
        return components
    }
    
    // MARK: get Bookmark
    mutating func getBookmark(userId: String) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.getBookmarkPath
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.userId, value: userId)
        ]
        
        return components
    }
    
    // MARK: Place Summary
    mutating func getPlaceSummary(placeId: String) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.placeSummaryPath
        
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

    // MARK: Review Info
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
    
    // MARK: Operation Hour
    mutating func getOperationHours(placeId: String) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.operationHourPath
        
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
        components.path = AVIRORequestAPI.checkPlacePath
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.title, value: placeModel.title),
            URLQueryItem(name: AVIRORequestAPI.address, value: placeModel.address),
            URLQueryItem(name: AVIRORequestAPI.x, value: placeModel.x),
            URLQueryItem(name: AVIRORequestAPI.y, value: placeModel.y)
        ]
        
        return components
    }
    
    // MARK: Check Place Report
    mutating func getChekPlaceReport(model: AVIROPlaceReportCheckDTO) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = AVIRORequestAPI.checkPlaceReport
        
        components.queryItems = [
            URLQueryItem(name: AVIRORequestAPI.placeId, value: model.placeId),
            URLQueryItem(name: AVIRORequestAPI.userId, value: model.userId)
        ]
        
        return components
    }
}
