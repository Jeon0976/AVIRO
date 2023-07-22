//
//  KakaoMapRequestManager.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/20.
//

import Foundation

protocol KakaoMapRequestProtocol {
    
}

final class KakaoMapRequestManager: KakaoMapRequestProtocol {
    private let session: URLSession
    
    let api = KakaoMapRequestAPI()
    
    var kakaoMapAPIKey = ""
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Keyword Search
    func kakaoMapKeywordSearch(query: String,
                               longitude: String,
                               latitude: String,
                               page: String,
                               completionHandler: @escaping ((KakaoMapResponseKeywordModel) -> Void)
    ) {
        guard let url = api.searchInfo(
            query: query,
            longitude: longitude,
            latitude: latitude,
            page: page
        ).url else { return }
                
        guard let keyUrl = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: keyUrl) as? [String: Any] else { return }
        
        kakaoMapAPIKey = (dictionary["KakaoMapAPI_ Authorization _Key"] as? String)!
                
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(kakaoMapAPIKey, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                // TODO: urlsession 오류
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let searchData = try? JSONDecoder().decode(KakaoMapResponseKeywordModel.self, from: data) {
                    completionHandler(searchData)
                }
            }
        }.resume()
    }
    
    // MARK: Coodinate Search
    func kakaoMapCoordinateSearch(longtitude: String,
                                  latitude: String,
                                  completionHandler: @escaping ((KakaoMapResponseCoordinateModel) -> Void)
    ) {
        guard let url = api.searchCoodinate(longitude: longtitude, latitude: latitude).url else { return }
        
        guard let keyUrl = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: keyUrl) as? [String: Any] else { return }
        
        kakaoMapAPIKey = (dictionary["KakaoMapAPI_ Authorization _Key"] as? String)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue(kakaoMapAPIKey, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                // TODO: urlsession 오류
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let searchData = try? JSONDecoder().decode(KakaoMapResponseCoordinateModel.self, from: data) {
                    completionHandler(searchData)
                }
            }
        }.resume()
    }
}
