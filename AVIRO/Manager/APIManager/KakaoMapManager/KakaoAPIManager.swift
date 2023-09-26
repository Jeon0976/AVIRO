//
//  KakaoMapRequestManager.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/20.
//

import Foundation

final class KakaoAPIManager: KakaoAPIManagerProtocol{
    let session: URLSession
    
    let api = KakaoMapRequestAPI()
    
    private var kakaoMapAPIKey: String? = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let key = dict["KakaoMapAPI_ Authorization _Key"] as? String else {
            print("Failed to load KakaoMapAPI from API.plist")
            return nil
        }
        return key
    }()
    
    private lazy var headers = ["Authorization": "\(kakaoMapAPIKey ?? "")"]
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Keyword Search
    func kakaoMapKeywordSearch(query: String,
                               longitude: String,
                               latitude: String,
                               page: String,
                               completionHandler: @escaping ((KakaoKeywordResultDTO) -> Void)
    ) {
        guard let url = api.searchPlace(
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
                if let searchData = try? JSONDecoder().decode(KakaoKeywordResultDTO.self, from: data) {
                    completionHandler(searchData)
                }
            }
        }.resume()
    }
    
    // MARK: Keyword Location Search
    func kakaoMapLocationSearch(query: String,
                                longitude: String,
                                latitude: String,
                                page: String,
                                isAccuracy: KakaoSearchHowToSort,
                                completionHandler: @escaping ((KakaoKeywordResultDTO) -> Void)
    ) {
        guard let url = api.searchLocation(
            query: query,
            longitude: longitude,
            latitude: latitude,
            page: page,
            isAccuracy: isAccuracy
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
                if let searchData = try? JSONDecoder().decode(KakaoKeywordResultDTO.self, from: data) {
                    completionHandler(searchData)
                }
            }
        }.resume()
    }
    
    // MARK: Coodinate Search
    func kakaoMapCoordinateSearch(longtitude: String,
                                  latitude: String,
                                  completionHandler: @escaping ((KakaoCoordinateSearchResultDTO) -> Void)
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
                if let searchData = try? JSONDecoder().decode(KakaoCoordinateSearchResultDTO.self, from: data) {
                    completionHandler(searchData)
                }
            }
        }.resume()
    }
    
    // MARK: Address Search
    func kakaoMapAddressSearch(address: String,
                               completionHandler: @escaping ((KakaoAddressPlaceDTO) -> Void)
    ) {
        guard let url = api.searchAddress(query: address).url else { return }
        
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
                if let searchData = try? JSONDecoder().decode(KakaoAddressPlaceDTO.self, from: data) {
                    completionHandler(searchData)
                }
            }
        }.resume()
    }
}
