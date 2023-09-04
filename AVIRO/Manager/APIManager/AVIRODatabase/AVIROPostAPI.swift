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
            fatalError()
        }
        return host
    }()
    
    static let placeEnrollPath = "/prod/map/add/place"
    static let placeListMatchedAVIROPath = "/prod/map/check/place"

    static let commentUploadPath = "/prod/map/add/comment"

    static let bookmarkPostPath = "/prod/map/add/bookmark"
    
    static let editMenuPath = "/prod/map/update/menu"
    
    static let userSignUpPath = "/prod/member/sign-up"
    static let userCheckPath = "/prod/member"
    static let userNicNameCheckPath = "/prod/member/check"
    static let userWithdrawPath = "/prod/member/withdraw"
    
    // MARK: Place Enroll
    mutating func placeEnroll() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.placeEnrollPath
        
        return components
    }
    
    // MARK: PlaceList Matched AVIRO
    mutating func placeListMatched() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.placeListMatchedAVIROPath
        
        return components
    }
    
    // MARK: Comment Upload
    mutating func commentUpload() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.commentUploadPath
        
        return components
    }
    
    // MARK: Bookmark Enroll/Delete
    mutating func bookmarkPost() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.bookmarkPostPath
        
        return components
    }
    
    // MARK: Edit Menu Data
    mutating func editMenu() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.editMenuPath
        
        return components
    }
    
    // MARK: UserInfoEnroll
    mutating func userInfoEnroll() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.userSignUpPath
        
        return components
    }
    
    // MARK: UserCheck
    mutating func userCheck() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.userCheckPath
        
        return components
    }
    
    // MARK: Nicname Check
    mutating func nicnameCheck() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.userNicNameCheckPath
        
        return components
    }
}
