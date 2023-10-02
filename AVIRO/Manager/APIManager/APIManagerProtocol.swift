//
//  APIManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/26.
//

import Foundation

protocol APIManagerProtocol {
    func performRequest<T: Decodable>(
        with url: URL,
        httpMethod: HTTPMethodType,
        requestBody: Data?,
        headers: [String: String]?,
        completionHandler: @escaping (Result<T, APIError>) -> Void
    )
}

extension APIManagerProtocol {
    func performRequest<T: Decodable>(
            with url: URL,
            httpMethod: HTTPMethodType = .get,
            requestBody: Data? = nil,
            headers: [String: String]? = nil,
            completionHandler: @escaping (Result<T, APIError>) -> Void
    ) {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.httpBody = requestBody
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            if let apiError = handleStatusCode(with: httpResponse.statusCode) {
                completionHandler(.failure(apiError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.badRequest))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decodedObject))
            } catch {
                completionHandler(.failure(.decodingError(error)))
            }
        }.resume()
        
    }
    
    private func handleStatusCode(with code: Int) -> APIError? {
        switch code {
        case 100..<200:
            return APIError.informationResponse
        case 200..<300:
            return nil
        case 300..<400:
            return APIError.redirectionRequired
        case 400..<500:
            return APIError.clientError(code)
        case 500...:
            return APIError.serverError(code)
        default:
            return APIError.badRequest
        }
    }
}
