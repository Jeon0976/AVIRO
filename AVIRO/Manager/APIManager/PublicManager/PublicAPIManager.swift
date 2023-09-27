//
//  PublicAPIRequestManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import Foundation

protocol PublicAPIManagerProtocol {
    func publicAddressSearch(
        currentPage: String,
        keyword: String,
        completion: @escaping (Result<PublicAddressDTO, Error>) -> Void)
}

final class PublicAPIManager: PublicAPIManagerProtocol {
    private let session: URLSession
    let api = PublicAPIRequestComponents()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Address Search
    func publicAddressSearch(
        currentPage: String,
        keyword: String,
        completion: @escaping (Result<PublicAddressDTO, Error>) -> Void
    ) {
        guard let url = api.searchAddress(currentPage: currentPage, keyword: keyword).url else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                let parser = XMLParser(data: data)
                let delegate = PublicXMLParserDelegate()
                parser.delegate = delegate
                if parser.parse() {
                    completion(.success(delegate.results))
                } else {
                    completion(.failure(NSError(
                        domain: "",
                        code: 500,
                        userInfo: [NSLocalizedDescriptionKey: "Parsing Error"]))
                    )
                }
            }
        }.resume()
    }
}
