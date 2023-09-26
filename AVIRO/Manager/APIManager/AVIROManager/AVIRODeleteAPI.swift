//
//  AVIRODeleteAPI.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/23.
//

import Foundation

struct AVIRODeleteAPI {
    
    static let scheme = "https"
    
    var host: String? = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let host = dict["AVIROHost"] as? String else {
            print("Failed to load AVIROHost from API.plist")
            return nil
        }
        return host
    }()
    
    let headers = ["Content-Type": "application/json"]

    // MARK: Path
    static let commentDeletePath = "/prod/map/update/comment"
    
    // MARK: Key
    static let commentId = "commentId"
    static let userId = "userId"
    
    mutating func deleteComment(model: AVIRODeleteReveiwDTO) -> URLComponents {
        let queryItems = [
            URLQueryItem(
                name: AVIRODeleteAPI.commentId,
                value: model.commentId
            ),
            URLQueryItem(
                name: AVIRODeleteAPI.userId,
                value: model.userId
            )
        ]
        
        return createURLComponents(
            path: AVIRODeleteAPI.commentDeletePath,
            queryItems: queryItems
        )
    }
}

extension AVIRODeleteAPI {
    mutating func createURLComponents(
        path: String,
        queryItems: [URLQueryItem]
    ) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIRORequestAPI.scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
}
