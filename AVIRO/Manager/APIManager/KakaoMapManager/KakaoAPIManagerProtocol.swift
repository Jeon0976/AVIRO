//
//  KakaoAPIManagerProtocol.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/26.
//

import Foundation

protocol KakaoAPIManagerProtocol: APIManagerProtocol {
    func keywordSearchPlace(
        with model: KakaoKeywordSearchDTO,
        completionHandler: @escaping (Result<KakaoKeywordResultDTO, APIError>) -> Void
    )
    func allSearchPlace(
        with model: KakaoKeywordSearchDTO,
        completionHandler: @escaping (Result<KakaoKeywordResultDTO, APIError>) -> Void
    )
    func coordinateSearch(
        with model: KakaoCoordinateSearchDTO,
        completionHandler: @escaping (Result<KakaoCoordinateSearchResultDTO, APIError>) -> Void
    )
    func addressSearch(
        with address: String,
        completionHandler: @escaping (Result<KakaoAddressPlaceDTO, APIError>) -> Void
    )
}
