//
//  KakaoMapRequestManager.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/20.
//

import Foundation

final class KakaoMapRequestManager {
    private let session: URLSession
    
    let api = KakaoMapRequestAPI()
    
    var kakaoMapAPIKey = ""
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func kakaoMapSearch(query: String,
                        longitude: String,
                        latitude: String,
                        page: String,
                        completionHandler: @escaping ((KakaoMapResponseModel) -> Void)
    ) {
        guard let url = api.searchInfo(
            query: query,
            longitude: longitude,
            latitude: latitude,
            page: page
        ).url else {
            // TODO: component 오류
            return }
                
        guard let keyUrl = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: keyUrl) as? [String: Any] else {
            // TODO: api key plist 불러오기 오류
            return }
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
                if let searchData = try? JSONDecoder().decode(KakaoMapResponseModel.self, from: data) {
                    completionHandler(searchData)
                }
            }
        }.resume()
    }
}
