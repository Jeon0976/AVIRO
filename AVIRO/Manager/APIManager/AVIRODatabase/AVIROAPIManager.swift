//
//  AVIROAPIModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

protocol AVIROAPIMangerProtocol {
    
}

final class AVIROAPIManager: AVIROAPIMangerProtocol {
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
                             time: String?,
                             completionHandler: @escaping((AVIROMapModel) -> Void)
    ) {
        guard let url = requestAPI.getNerbyStore(
            longitude: longitude,
            latitude: latitude,
            wide: wide,
            time: time
        ).url else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
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
    
    // MARK: Get Bookmark
    func getBookmarkModels(userId: String, completionHandler: @escaping(AVIROBookmarkModel) -> Void) {
        guard let url = requestAPI.getBookmark(userId: userId).url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let bookmarkModel = try? JSONDecoder().decode(AVIROBookmarkModel.self, from: data) {
                    completionHandler(bookmarkModel)
                }
            }
        }.resume()
    }
    
    // MARK: Post Bookmark
    func postBookmarkModel(
        bookmarkModel: BookmarkPostModel,
        completionHandler: @escaping((BookmarkPostAfterData) -> Void)
    ) {
        guard let url = postAPI.bookmarkPost().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(bookmarkModel) else { return }
        
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
                if let afterData = try? JSONDecoder().decode(BookmarkPostAfterData.self, from: data) {
                    completionHandler(afterData)
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
    
    // MARK: Get Place Summary
    func getPlaceSummary(placeId: String,
                         completionHandler: @escaping((AVIROSummaryModel) -> Void)
    ) {
        guard let url = requestAPI.getPlaceSummary(placeId: placeId).url else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let placeSummary = try? JSONDecoder().decode(AVIROSummaryModel.self, from: data) {
                    completionHandler(placeSummary)
                    print(placeSummary.data)
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
                    completionHandler(menuData)
                }
            }
        }.resume()
    }
    // MARK: Get Comment Info
    func getCommentInfo(placeId: String,
                        completionHandler: @escaping((AVIROReviewsModel) -> Void)
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
                if let commentData = try? JSONDecoder().decode(AVIROReviewsModel.self, from: data) {
                    completionHandler(commentData)
                }
            }
        }.resume()
    }
    
    // MARK: Get Operation Hour
    func getOperationHour(
        placeId: String,
        completionHandler: @escaping((AVIROOperationHourModel) -> Void)
    ) {
        guard let url = requestAPI.getOperationHours(placeId: placeId).url else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let operationHoursData = try? JSONDecoder().decode(AVIROOperationHourModel.self, from: data) {
                    completionHandler(operationHoursData)
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
        guard let url = postAPI.userInfoEnroll().url else { print("url error"); return}
        
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
    func postPlaceModel(_ veganModel: VeganModel, completionHandler: @escaping((PostResultDTO) -> Void)) {
        guard let url = postAPI.placeEnroll().url else { print("url error"); return }
        
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
                if let placeResponse = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                    completionHandler(placeResponse)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Comment Model
    func postCommentModel(_ commentModel: AVIROCommentPost) {
        guard let url = postAPI.commentUpload().url else { return }
        
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
    
    // MARK: Post Edit Comment
    func postEditCommentModel(
        _ commentEditModel: AVIROEditCommentPost,
        completionHandler: @escaping((PostResultDTO) -> Void)) {
            guard let url = postAPI.commentEdit().url else { return }
            
            guard let jsonData = try? JSONEncoder().encode(commentEditModel) else {
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
                    if let placeResponse = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                        completionHandler(placeResponse)
                    }
                    return
                }
            }.resume()
        }
    
    // MARK: Post Delete Comment
    func postDeleteCommentModel(
        _ commentDeleteModel: AVIRODeleteCommentPost,
        completionHandler: @escaping((PostResultDTO) -> Void)) {
            guard let url = postAPI.commentDelete().url else { return }
            
            guard let jsonData = try? JSONEncoder().encode(commentDeleteModel) else {
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
                    if let placeResponse = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                        completionHandler(placeResponse)
                    }
                    return
                }
            }.resume()
        }
    
    // MARK: Post Nicname Check
    func postCheckNickname(_ nicname: NicknameCheckInput, completionHandler: @escaping ((NicknameCheck) -> Void)) {
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
                if let userCheck = try? JSONDecoder().decode(NicknameCheck.self, from: data) {
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
    
    // MARK: Post Edit Menu
    func postEditMenu(
        _ editMenuModel: AVIROEditMenuModel,
        completionHandler: @escaping((PostResultDTO) -> Void)
    ) {
        guard let url = postAPI.editMenu().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(editMenuModel) else { return }
        
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
                if let result = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Edit Place Location
    func postEditPlaceLocation(
        _ editModel: AVIROEditLocationDTO,
        completionHandler: @escaping((PostResultDTO) -> Void)
    ) {
        guard let url = postAPI.editPlaceLocation().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(editModel) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
            
            if let data = data {
                if let result = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Edit Place Phone
    func postEditPlacePhone(
        _ editModel: AVIROEditPhoneDTO,
        completionHandler: @escaping((PostResultDTO) -> Void)
    ) {
        guard let url = postAPI.editPlacePhone().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(editModel) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
            
            if let data = data {
                if let result = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }

    // MARK: Post Edit Place Operation
    func postEditPlaceOperation(
        _ editModel: AVIROEditOperationTimeDTO,
        completionHandler: @escaping((PostResultDTO) -> Void)
    ) {
        guard let url = postAPI.editPlaceOperation().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(editModel) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
            
            if let data = data {
                if let result = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }

    // MARK: Post Edit Place URL
    func postEditPlaceURL(
        _ editModel: AVIROEditURLDTO,
        completionHandler: @escaping((PostResultDTO) -> Void)
    ) {
        guard let url = postAPI.editPlaceURL().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(editModel) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
            
            if let data = data {
                if let result = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }

    // MARK: Get Place Report Dublicated
    func getPlaceReportIsDuplicated(
        _ checkReportModel: AVIROPlaceReportCheckDTO,
        completionHandler: @escaping((AVIROPlaceReportCheckResultDTO) -> Void)
    ) {
        guard let url = requestAPI.getChekPlaceReport(model: checkReportModel).url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let isReported = try? JSONDecoder().decode(AVIROPlaceReportCheckResultDTO.self, from: data) {
                    completionHandler(isReported)
                }
            }
        }.resume()
    }
    
    // MARK: Post Place Report
    func postPlaceReport(
        _ reportModel: AVIROPlaceReportDTO,
        completionHandler: @escaping((PostResultDTO) -> Void)
    ) {
        guard let url = postAPI.placeReport().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(reportModel) else { return }
        
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
                if let result = try? JSONDecoder().decode(PostResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }
}
