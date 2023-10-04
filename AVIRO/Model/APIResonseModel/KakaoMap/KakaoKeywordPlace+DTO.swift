//
//  KakaoMapResponseModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

struct KakaoKeywordSearchDTO {
    let query: String
    let lng: String
    let lat: String
    var page: String
    let isAccuracy: KakaoSearchHowToSort?
}
