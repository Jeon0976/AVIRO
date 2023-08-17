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
    func getNerbyPlaceModels(longitude: String,
                             latitude: String,
                             wide: String,
                             completionHandler: @escaping((AVIROMapModel) -> Void)
    ) {
        guard let url = requestAPI.getNerbyStore(
            longitude: longitude,
            latitude: latitude,
            wide: wide
        ).url else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let mapDatas = try? JSONDecoder().decode(AVIROMapModel.self, from: data) {
                    completionHandler(mapDatas)
                }
            }
        }.resume()
    }
    
    // MARK: Get Place Info
    func getPlaceInfo(placeId: String,
                      completionHandler: @escaping((AVIROPlaceModel) -> Void)
    ) {
        guard let url = requestAPI.getPlaceInfo(placeId: placeId).url else {
            print("url Error")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let placeData = try? JSONDecoder().decode(AVIROPlaceModel.self, from: data) {
                    completionHandler(placeData)
                }
            }
        }.resume()
    }
    
    // MARK: Get Menu Info
    func getMenuInfo(placeId: String,
                     completionHandler: @escaping((AVIROMenuModel) -> Void)
    ) {
        guard let url = requestAPI.getMenuInfo(placeId: placeId).url else {
            print("url Error")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }

            if let data = data {
                if let menuData = try? JSONDecoder().decode(AVIROMenuModel.self, from: data) {
                    print(menuData)
                    completionHandler(menuData)
                }
            }
        }.resume()
    }
    // MARK: Get Comment Info
    func getCommentInfo(placeId: String,
                        completionHandler: @escaping((AVIROCommentModel) -> Void)
    ) {
        guard let url = requestAPI.getCommentInfo(placeId: placeId).url else {
            print("url Error")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }

            if let data = data {
                if let commentData = try? JSONDecoder().decode(AVIROCommentModel.self, from: data) {
                    completionHandler(commentData)
                }
            }
        }.resume()
    }
    
    // MARK: Check User Model
    func postCheckUserModel(_ userToken: UserCheckInput, completionHandler: @escaping((CheckUser) -> Void)) {
        guard let url = postAPI.userCheck().url else { print("url error"); return}
        
        guard let jsonData = try? JSONEncoder().encode(userToken) else {
            print("JSON Encode Error")
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
            
            if let data = data {
                if let userCheck = try? JSONDecoder().decode(CheckUser.self, from: data) {
                    completionHandler(userCheck)
                }
                return
            }
            
            guard response != nil else {
                print("respose error")
                return
            }
            print(response ?? "")
        }.resume()
    }
    
    // MARK: Post UserInfo Model
    func postUserModel(_ userModel: UserInfoModel,
                       completionHandler: @escaping((UserInrollResponse) -> Void)) {
        guard let url = postAPI.userInfoInroll().url else { print("url error"); return}
        
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
            print("JSON Encode Error")
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
            
            if let data = data {
                if let userInfo = try? JSONDecoder().decode(UserInrollResponse.self, from: data) {
                    completionHandler(userInfo)
                }
                return
            }
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
        }.resume()
    }
    
    // MARK: Post Place Model
    func postPlaceModel(_ veganModel: VeganModel, completionHandler: @escaping((VeganPlaceResponse) -> Void)) {
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
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
            
            if let data = data {
                if let placeResponse = try? JSONDecoder().decode(VeganPlaceResponse.self, from: data) {
                    completionHandler(placeResponse)
                }
                return 
            }
        }.resume()
    }
    
    // MARK: Post Comment Model
    func postCommentModel(_ commentModel: AVIROCommentPost) {
        guard let url = postAPI.commentInroll().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(commentModel) else {
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
    
    // MARK: Post Nicname Check
    func postCheckNicname(_ nicname: NicnameCheckInput, completionHandler: @escaping ((NicnameCheck) -> Void)) {
        guard let url = postAPI.nicnameCheck().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(nicname) else {
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
            
            if let data = data {
                if let userCheck = try? JSONDecoder().decode(NicnameCheck.self, from: data) {
                    completionHandler(userCheck)
                }
                return
            }
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
        }.resume()
    }
    
    // MARK: Get Check Place
    func getCheckPlace(placeModel: PlaceCheckModel, completionHandler: @escaping((AVIROCheckPlaceModel) -> Void)
    ) {
        guard let url = requestAPI.getCheckPlace(placeModel: placeModel).url else {
            print("url Error")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }

            if let data = data {
                if let menuData = try? JSONDecoder().decode(AVIROCheckPlaceModel.self, from: data) {
                    completionHandler(menuData)
                }
            }
        }.resume()
    }
    
    // MARK: Post PlaceList Matched AVIRO
    func postPlaceListMatched(
        _ placeArray: PlaceModelBeforeMatchedAVIRO,
        completionHandler: @escaping((PlaceModelAfterMatchedAVIRO) -> Void)
    ) {
        guard let url = postAPI.placeListMatched().url else { print("url error"); return }
        
        guard let jsonData = try? JSONEncoder().encode(placeArray) else {
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
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
            
            if let data = data {
                if let placeResponse = try? JSONDecoder().decode(PlaceModelAfterMatchedAVIRO.self, from: data) {
                    completionHandler(placeResponse)
                }
                return
            }
        }.resume()
    }
}
