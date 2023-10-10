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
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "서버에 접속하는 데 문제가 발생했습니다.\n잠시 후 다시 시도해주세요."
        case .networkError:
            return "네트워크 연결을 확인해주세요."
        case .encodingError:
            return "데이터 처리 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요."
        case .decodingError:
            return "서버 응답을 처리하는 데 문제가 발생했습니다.\n잠시 후 다시 시도해주세요."
        case .invalidResponse:
            return "서버 응답이 유효하지 않습니다.\n잠시 후 다시 시도해주세요."
        case .informationResponse:
            return "서버로부터의 정보를 확인해주세요."
        case .redirectionRequired:
            return "요청한 정보가 변경되었습니다.\n잠시 후 다시 시도해주세요."
        case .clientError:
            return "잘못된 요청입니다.\n다시 시도해주세요."
        case .serverError:
            return "서버에서 문제가 발생했습니다.\n잠시 후 다시 시도해주세요."
        case .badRequest:
            return "요청 정보가 올바르지 않습니다.\n확인 후 다시 시도해주세요."
        }
    }
}

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
