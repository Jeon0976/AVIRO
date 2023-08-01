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
    static let commentInrollPath = "/prod/map/add/comment"
    static let userInfo = "/prod/member/sign-up"
    static let userCheck = "/prod/member"
    static let userNicNameCheck = "/prod/member/check"
    static let userWithdraw = "/prod/member/withdraw"
    
    // MARK: Place Inroll
    mutating func placeInroll() -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.placeInrollPath
        
        return components
    }
    
    // MARK: CommentInroll
    mutating func commentInroll() -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.commentInrollPath
        
        return components
    }
    
    // MARK: UserInfoInroll
    mutating func userInfoInroll() -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.userInfo
        
        return components
    }
    
    // MARK: UserCheck
    mutating func userCheck() -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.userCheck
        
        return components
    }
    
    // MARK: Nicname Check
    mutating func nicnameCheck() -> URLComponents {
        var components = URLComponents()
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.userNicNameCheck
        
        return components
    }
    
}
