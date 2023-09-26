//
//  APITypes.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/26.
//

import Foundation

enum APIError: Error {
    case urlError
    case networkError(Error)
    case encodingError
    case decodingError(Error)
    case invalidResponse
    case informationResponse
    case redirectionRequired
    case clientError(Int)
    case serverError(Int)
    case badRequest
}

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
