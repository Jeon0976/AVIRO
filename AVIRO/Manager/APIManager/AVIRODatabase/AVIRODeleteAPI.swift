//
//  AVIRODeleteAPI.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/23.
//

import Foundation

struct AVIRODeleteAPI {
    
    static let scheme = "https"
    
    lazy var host: String = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let host = dict["AVIROHost"] as? String else {
            fatalError()
        }
        return host
    }()
    
    // MARK: Path
    static let commentDeletePath = "/prod/map/update/comment"
    
    // MARK: Key
    static let commentId = "commentId"
    static let userId = "userId"
    
    mutating func deleteComment(commentId: String, userId: String) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIRODeleteAPI.scheme
        components.host = host
        components.path = AVIRODeleteAPI.commentDeletePath
        
        components.queryItems = [
            URLQueryItem(name: AVIRODeleteAPI.commentId, value: commentId),
            URLQueryItem(name: AVIRODeleteAPI.userId, value: userId)
        ]
        
        return components
    }
}
