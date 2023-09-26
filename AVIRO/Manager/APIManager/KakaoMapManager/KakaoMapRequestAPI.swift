//
//  KakaoMapRequestAPI.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

struct KakaoMapRequestAPI {
    // MARK: 주소
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let keywordPath = "/v2/local/search/keyword"
    static let coordinatePath = "/v2/local/geo/coord2address"
    static let addressPath = "/v2/local/search/address"
    
    // MARK: key
    static let query = "query"
    static let category = "category_group_code"
    static let longitude = "x"
    static let latitude = "y"
    static let sort = "sort"
    static let page = "page"
    
    // MARK: static Value
    // 사용자 기준 거리순 정렬
    static let accuracy = "accuracy"
    static let distance = "distance"
    // CE7: 카페, FD6: 음식점, SW8: 지하철역, AT4: 관광명소, PO3: 공공기관
    static let inrollCategory = "CE7, FD6"
    static let mainSearchCategory = "CE7, FD6, SW8, AT4, PO3"
    
    // MARK: Search 등록하기 Components 만들기 함수
    func searchPlace(model: KakaoKeywordSearchDTO) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = KakaoMapRequestAPI.scheme
        components.host = KakaoMapRequestAPI.host
        components.path = KakaoMapRequestAPI.keywordPath
        
        components.queryItems = [
            URLQueryItem(
                name: KakaoMapRequestAPI.query,
                value: model.query
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.category,
                value: KakaoMapRequestAPI.inrollCategory
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.longitude,
                value: model.lng
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.latitude,
                value: model.lat
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.sort,
                value: KakaoMapRequestAPI.accuracy
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.page,
                value: model.page
            )
        ]
        
        return components
    }
    
    // MARK: Search Location Components 만들기 함수
    func searchLocation(model: KakaoKeywordSearchDTO) -> URLComponents {
        guard let isAccuracy = model.isAccuracy else { return URLComponents() }
        var components = URLComponents()
        
        components.scheme = KakaoMapRequestAPI.scheme
        components.host = KakaoMapRequestAPI.host
        components.path = KakaoMapRequestAPI.keywordPath
        
        components.queryItems = [
            URLQueryItem(
                name: KakaoMapRequestAPI.query,
                value: model.query
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.category,
                value: KakaoMapRequestAPI.mainSearchCategory
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.longitude,
                value: model.lng
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.latitude,
                value: model.lat
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.sort,
                value: isAccuracy ==
                KakaoSearchHowToSort.accuracy ? KakaoMapRequestAPI.accuracy : KakaoMapRequestAPI.distance
            ),
            URLQueryItem(
                name: KakaoMapRequestAPI.page,
                value: model.page
            )
        ]
        
        return components
    }
    
    // MARK: Coordinate Search Components 만들기 함수
    func searchCoodinate(model: KakaoCoordinateSearchDTO) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = KakaoMapRequestAPI.scheme
        components.host = KakaoMapRequestAPI.host
        components.path = KakaoMapRequestAPI.coordinatePath
        
        components.queryItems = [
            URLQueryItem(name: KakaoMapRequestAPI.longitude, value: model.lng),
            URLQueryItem(name: KakaoMapRequestAPI.latitude, value: model.lat)
        ]
        
        return components
    }
    
    func searchAddress(query: String) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = KakaoMapRequestAPI.scheme
        components.host = KakaoMapRequestAPI.host
        components.path = KakaoMapRequestAPI.addressPath
        
        components.queryItems = [
            URLQueryItem(name: KakaoMapRequestAPI.query, value: query)
        ]
        
        return components
    }
}
