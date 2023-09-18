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
    static let placeListReportPath = "/prod/map/report/place"
    
    static let editPlaceLocationPath = "/prod/map/report/address"
    static let editPlacePhonePath = "/prod/map/report/phone"
    static let editPlaceOperationPath = "/prod/map/update/time"
    static let editPlaceURLPath = "/prod/map/report/url"
    
    static let commentUploadPath = "/prod/map/add/comment"
    static let commentEditPath = "/prod/map/update/comment"
    static let commentDeletePath = "/prod/map/delete/comment"

    static let bookmarkPostPath = "/prod/map/add/bookmark"
    
    static let editMenuPath = "/prod/map/update/menu"
    
    static let userSignUpPath = "/prod/member/sign-up"
    static let userCheckPath = "/prod/member/info"
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
    
    // MARK: PlaceList Report
    mutating func placeReport() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.placeListReportPath
        
        return components
    }
    
    // MARK: Edit Place Location
    mutating func editPlaceLocation() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.editPlaceLocationPath
        
        return components
    }
    
    // MARK: Edit Place Phone
    mutating func editPlacePhone() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.editPlacePhonePath
        
        return components
    }
    
    // MARK: Edit Place Operation
    mutating func editPlaceOperation() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.editPlaceOperationPath
        
        return components
    }
    
    // MARK: Edit Place URL
    mutating func editPlaceURL() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.editPlaceURLPath
        
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
    
    // MARK: Comment Edit
    mutating func commentEdit() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.commentEditPath
        
        return components
    }
    
    // MARK: Comment Delete
    mutating func commentDelete() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.commentDeletePath
        
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
    
    // MARK: user Sign up 
    mutating func userSignup() -> URLComponents {
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
    
    mutating func userWithdraw() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = AVIROPostAPI.scheme
        components.host = host
        components.path = AVIROPostAPI.userWithdrawPath
        
        return components
    }
}
