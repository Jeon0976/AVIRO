//
//  KakaoMapRequestManager.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/20.
//

import Foundation

final class KakaoAPIManager: KakaoAPIManagerProtocol {
    let session: URLSession
    
    let api = KakaoMapRequestAPI()
    
    private var kakaoMapAPIKey: String? = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let key = dict["KakaoMapAPI_ Authorization _Key"] as? String else {
            return nil
        }
        return key
    }()
    
    private lazy var headers = ["Authorization": "\(kakaoMapAPIKey ?? "")"]
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func keywordSearchPlace(
        with model: KakaoKeywordSearchDTO,
        completionHandler: @escaping (Result<KakaoKeywordResultDTO, APIError>) -> Void
    ) {
        guard let url = api.searchPlace(model: model).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(
            with: url,
            headers: headers,
            completionHandler: completionHandler)
    }
    
    func allSearchPlace(
        with model: KakaoKeywordSearchDTO,
        completionHandler: @escaping (Result<KakaoKeywordResultDTO, APIError>) -> Void
    ) {
        guard let url = api.searchLocation(model: model).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(
            with: url,
            headers: headers,
            completionHandler: completionHandler
        )
    }
    
    func coordinateSearch(
        with model: KakaoCoordinateSearchDTO,
        completionHandler: @escaping (Result<KakaoCoordinateSearchResultDTO, APIError>) -> Void
    ) {
        guard let url = api.searchCoodinate(model: model).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(
            with: url,
            headers: headers,
            completionHandler: completionHandler
        )
    }
    
    func addressSearch(
        with address: String,
        completionHandler: @escaping (Result<KakaoAddressPlaceDTO, APIError>) -> Void
    ) {
        guard let url = api.searchAddress(query: address).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(
            with: url,
            headers: headers,
            completionHandler: completionHandler
        )
    }
}
