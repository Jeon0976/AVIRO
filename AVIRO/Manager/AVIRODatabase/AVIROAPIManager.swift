//
//  AVIROAPIModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

final class AVIROAPIManager {
    private let session: URLSession
    
    var postAPI = AVIROPostAPI()
    var requestAPI = AVIRORequestAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Get Place Models
    func getPlaceModels(
        longitude: String,
        latitude: String,
        wide: String,
        completionHandler: @escaping((AVIROMapModel) -> Void)
    ) {
        guard let url = requestAPI.responseAllData(
            longitude: longitude,
            latitude: latitude,
            wide: wide
        ).url else {
            print ("url error")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                if let mapDatas = try? JSONDecoder().decode(AVIROMapModel.self, from: data) {
                    completionHandler(mapDatas)
                }
            }
        }.resume()
    }
    
    // MARK: Post Place Model
    func postPlaceModel(_ veganModel: VeganModel) {
        guard let url = postAPI.placeInroll().url else { print("url error"); return }
        
        guard let jsonData = try? JSONEncoder().encode(veganModel) else {
            print("JSOE Encode ERROR")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("error")
                return
            }
            
            guard data != nil else {
                print("data error")
                return
            }
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
        }.resume()
    }
}
