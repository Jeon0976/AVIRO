//
//  PublicAPIRequestComponents.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import Foundation

struct PublicAPIRequestComponents {
    // MARK: 주소
    static let scheme = "https"
    static let host = "business.juso.go.kr"
    
    static let addressPath = "/addrlink/addrLinkApi.do"
    
    // MARK: Key
    static let currentPage = "currentPage"
    static let countPerPage = "countPerPage"
    static let confmKey = "confmKey"
    static let keyword = "keyword"
    
    // MARK: Static Value
    static let page = "20"
    
    func searchAddress(currentPage: String,
                       keyword: String
    ) -> URLComponents {
        guard let keyUrl = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: keyUrl) as? [String: Any] else { return URLComponents() }
        
        let apiKey = (dictionary["PublicAPI_confmKey"] as? String)!
        
        var components = URLComponents()
        
        components.scheme = PublicAPIRequestComponents.scheme
        components.host = PublicAPIRequestComponents.host
        components.path = PublicAPIRequestComponents.addressPath
        
        components.queryItems = [
            URLQueryItem(name: PublicAPIRequestComponents.currentPage, value: currentPage),
            URLQueryItem(name: PublicAPIRequestComponents.countPerPage, value: PublicAPIRequestComponents.page),
            URLQueryItem(name: PublicAPIRequestComponents.confmKey, value: apiKey),
            URLQueryItem(name: PublicAPIRequestComponents.keyword, value: keyword)
        ]
        
        return components
    }
}
