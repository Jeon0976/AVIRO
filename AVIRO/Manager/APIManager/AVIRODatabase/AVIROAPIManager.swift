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
    func getNerbyPlaceModels(
        mapModel: AVIROMapModelDTO,
        completionHandler: @escaping((AVIROMapModelResultDTO) -> Void)
    ) {
        guard let url = requestAPI.getNerbyStore(
            longitude: mapModel.longitude,
            latitude: mapModel.latitude,
            wide: mapModel.wide,
            time: mapModel.time
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
                if let mapDatas = try? JSONDecoder().decode(AVIROMapModelResultDTO.self, from: data) {
                    completionHandler(mapDatas)
                }
            }
        }.resume()
    }
    
    // MARK: Get Bookmark
    func getBookmarkModels(
        userId: String,
        completionHandler: @escaping(AVIROBookmarkModelResultDTO) -> Void
    ) {
        guard let url = requestAPI.getBookmark(userId: userId).url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let bookmarkModel = try? JSONDecoder().decode(AVIROBookmarkModelResultDTO.self, from: data) {
                    completionHandler(bookmarkModel)
                }
            }
        }.resume()
    }
    
    // MARK: Post Bookmark
    func postBookmarkModel(
        bookmarkModel: AVIROUpdateBookmarkDTO,
        completionHandler: @escaping((AVIROUpdateBookmarkResultDTO) -> Void)
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
                if let afterData = try? JSONDecoder().decode(AVIROUpdateBookmarkResultDTO.self, from: data) {
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
                         completionHandler: @escaping((AVIROSummaryResultDTO) -> Void)
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
                if let placeSummary = try? JSONDecoder().decode(AVIROSummaryResultDTO.self, from: data) {
                    completionHandler(placeSummary)
                    print(placeSummary.data)
                }
            }
        }.resume()
    }
    
    // MARK: Get Place Info
    func getPlaceInfo(placeId: String,
                      completionHandler: @escaping((AVIROPlaceInfoResultDTO) -> Void)
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
                if let placeData = try? JSONDecoder().decode(AVIROPlaceInfoResultDTO.self, from: data) {
                    completionHandler(placeData)
                }
            }
        }.resume()
    }
    
    // MARK: Get Menu Info
    func getMenuInfo(placeId: String,
                     completionHandler: @escaping((AVIROMenusResultDTO) -> Void)
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
                if let menuData = try? JSONDecoder().decode(AVIROMenusResultDTO.self, from: data) {
                    completionHandler(menuData)
                }
            }
        }.resume()
    }
    // MARK: Get Comment Info
    func getCommentInfo(placeId: String,
                        completionHandler: @escaping((AVIROReviewsResultDTO) -> Void)
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
                if let commentData = try? JSONDecoder().decode(AVIROReviewsResultDTO.self, from: data) {
                    completionHandler(commentData)
                }
            }
        }.resume()
    }
    
    // MARK: Get Operation Hour
    func getOperationHour(
        placeId: String,
        completionHandler: @escaping((AVIROOperationHoursDTO) -> Void)
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
                if let operationHoursData = try? JSONDecoder().decode(AVIROOperationHoursDTO.self, from: data) {
                    completionHandler(operationHoursData)
                }
            }
        }.resume()
    }
    
    // MARK: Check User Model
    func postCheckAppleUserModel(
        _ userToken: AVIROAppleUserCheckMemberDTO,
        completionHandler: @escaping((AVIROAfterAppleUserCheckMemberDTO) -> Void)
    ) {
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
                if let userCheck = try? JSONDecoder().decode(AVIROAfterAppleUserCheckMemberDTO.self, from: data) {
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
    func postUserSignupModel(
        _ userModel: AVIROUserSignUpDTO,
        completionHandler: @escaping((AVIROUserSignUpResultDTO) -> Void)
    ) {
        guard let url = postAPI.userSignup().url else { print("url error"); return}
        
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
                if let resultModel = try? JSONDecoder().decode(AVIROUserSignUpResultDTO.self, from: data) {
                    completionHandler(resultModel)
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
    func postPlaceModel(_ veganModel: AVIROEnrollPlaceDTO, completionHandler: @escaping((AVIROResultDTO) -> Void)) {
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
                if let placeResponse = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(placeResponse)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Comment Model
    func postCommentModel(
        _ commentModel: AVIROEnrollReviewDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
    ) {
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
            
            guard response != nil else {
                print(response ?? "response error")
                return
            }
            
            if let data = data {
                if let placeResponse = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(placeResponse)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Edit Comment
    func postEditCommentModel(
        _ commentEditModel: AVIROEditReviewDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)) {
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
                    if let placeResponse = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                        completionHandler(placeResponse)
                    }
                    return
                }
            }.resume()
        }
    
    // MARK: Post Delete Comment
    func postDeleteCommentModel(
        _ commentDeleteModel: AVIRODeleteReveiwDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)) {
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
                    if let placeResponse = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                        completionHandler(placeResponse)
                    }
                    return
                }
            }.resume()
        }
    
    // MARK: Post Comment Report Model
    func postCommentReportModel(
        _ commentReportModel: AVIROReportReviewDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
    ) {
        guard let url = postAPI.commentReport().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(commentReportModel) else {
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
                if let placeResponse = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(placeResponse)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Nicname Check
    func postCheckNickname(
        _ nickname: AVIRONicknameIsDuplicatedCheckDTO,
        completionHandler: @escaping ((AVIRONicknameIsDuplicatedCheckResultDTO) -> Void)
    ) {
        guard let url = postAPI.nicknameCheck().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(nickname) else {
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
                if let userCheck = try? JSONDecoder().decode(AVIRONicknameIsDuplicatedCheckResultDTO.self, from: data) {
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
    
    // MARK: Pst Nickname Change
    func postChangeNickname(
        _ nickname: AVIRONicknameChagneableDTO,
        completionHandler: @escaping ((AVIROResultDTO) -> Void)
    ) {
        guard let url = postAPI.nicknameChange().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(nickname) else {
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
                if let userCheck = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
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
    
    // MARK: Post Withdrawal User
    func postUserWithrawal(
        _ userModel: AVIROUserWithdrawDTO,
        completionHandler: @escaping ((AVIROResultDTO) -> Void)
    ) {
        guard let url = postAPI.userWithdraw().url else { return }
        
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
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
                if let resultModel = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(resultModel)
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
    func getCheckPlace(placeModel: AVIROCheckPlaceDTO, completionHandler: @escaping((AVIROCheckPlaceResultDTO) -> Void)
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
                if let menuData = try? JSONDecoder().decode(AVIROCheckPlaceResultDTO.self, from: data) {
                    completionHandler(menuData)
                }
            }
        }.resume()
    }
    
    // MARK: Post PlaceList Matched AVIRO
    func postPlaceListMatched(
        _ placeArray: AVIROBeforeComparePlaceDTO,
        completionHandler: @escaping((AVIROAfterComparePlaceDTO) -> Void)
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
                if let placeResponse = try? JSONDecoder().decode(AVIROAfterComparePlaceDTO.self, from: data) {
                    completionHandler(placeResponse)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Edit Menu
    func postEditMenu(
        _ editMenuModel: AVIROEditMenuModel,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
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
                if let result = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Edit Place Location
    func postEditPlaceLocation(
        _ editModel: AVIROEditLocationDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
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
                if let result = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Post Edit Place Phone
    func postEditPlacePhone(
        _ editModel: AVIROEditPhoneDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
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
                if let result = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }

    // MARK: Post Edit Place Operation
    func postEditPlaceOperation(
        _ editModel: AVIROEditOperationTimeDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
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
                if let result = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }

    // MARK: Post Edit Place URL
    func postEditPlaceURL(
        _ editModel: AVIROEditURLDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
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
                if let result = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
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
        _ reportModel: AVIROReportPlaceDTO,
        completionHandler: @escaping((AVIROResultDTO) -> Void)
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
                if let result = try? JSONDecoder().decode(AVIROResultDTO.self, from: data) {
                    completionHandler(result)
                }
                return
            }
        }.resume()
    }
    
    // MARK: Get Place Report Dublicated
    func getMyContributionCount(
        _ userId: String,
        completionHandler: @escaping((AVIROMyContributionCountDTO) -> Void)
    ) {
        guard let url = requestAPI.getMyContributionCount(userId: userId).url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let myContribution = try? JSONDecoder().decode(AVIROMyContributionCountDTO.self, from: data) {
                    completionHandler(myContribution)
                }
            }
        }.resume()
    }
}
