//
//  QuerySingleTon.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

/// 검색한 query 문
final class QuerySingleTon {
    static let shared = QuerySingleTon()
    
    var query: String?
    
    private init(query: String? = nil) {
        self.query = query
    }
}
