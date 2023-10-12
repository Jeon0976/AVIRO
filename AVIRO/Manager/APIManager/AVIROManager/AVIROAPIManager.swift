//
//  AVIROAPIModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

final class AVIROAPIManager: AVIROAPIMangerProtocol {
    var session: URLSession
    
    var postAPI = AVIROPostAPI()
    var requestAPI = AVIRORequestAPI()
    var deleteAPI = AVIRODeleteAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
        
    // MARK: Marker Refer
    func loadNerbyPlaceModels(
        with mapModel: AVIROMapModelDTO,
        completionHandler: @escaping (Result<AVIROMapModelResultDTO, APIError>) -> Void
    ) {
        guard let url = requestAPI.getNerbyStore(with: mapModel).url else {
            completionHandler(.failure(.urlError))
            return
        }

        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func loadBookmarkModels(
        with userId: String,
        completionHandler: @escaping (Result<AVIROBookmarkModelResultDTO, APIError>) -> Void
    ) {
        guard let url = requestAPI.getBookmark(userId: userId).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func createBookmarkModel(
        with bookmarkModel: AVIROUpdateBookmarkDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.bookmarkPost().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(bookmarkModel) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    // MARK: Check Refer
    func checkPlaceOne(
        with placeModel: AVIROCheckPlaceDTO,
        completionHandler: @escaping (Result<AVIROCheckPlaceResultDTO, APIError>) -> Void
    ) {
        guard let url = requestAPI.getCheckPlace(placeModel: placeModel).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func checkPlaceList(
        with placeArray: AVIROBeforeComparePlaceDTO,
        completionHandler: @escaping (Result<AVIROAfterComparePlaceDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.placeListMatched().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(placeArray) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func checkPlaceReportIsDuplicated(
        with checkReportModel: AVIROPlaceReportCheckDTO,
        completionHandler: @escaping (Result<AVIROPlaceReportCheckResultDTO, APIError>) -> Void
    ) {
        guard let url = requestAPI.getCheckPlaceReport(model: checkReportModel).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    // MARK: Create Refer
    func createPlaceModel(
        with placeModel: AVIROEnrollPlaceDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.placeEnroll().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(placeModel) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func createReview(
        with reviewModel: AVIROEnrollReviewDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.commentUpload().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(reviewModel) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    // MARK: Load Refer
    func loadPlaceSummary(
        with placeId: String,
        completionHandler: @escaping (Result<AVIROSummaryResultDTO, APIError>
        ) -> Void) {
        guard let url = requestAPI.getPlaceSummary(placeId: placeId).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func loadPlaceInfo(
        with placeId: String,
        completionHandler: @escaping (Result<AVIROPlaceInfoResultDTO, APIError>
        ) -> Void) {
        guard let url = requestAPI.getPlaceInfo(placeId: placeId).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func loadMenus(
        with placeId: String,
        completionHandler: @escaping (Result<AVIROMenusResultDTO, APIError>
        ) -> Void) {
        guard let url = requestAPI.getMenuInfo(placeId: placeId).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func loadReviews(
        with placeId: String,
        completionHandler: @escaping (Result<AVIROReviewsResultDTO, APIError>
        ) -> Void) {
        guard let url = requestAPI.getCommentInfo(placeId: placeId).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func loadOperationHours(
        with placeId: String,
        completionHandler: @escaping (Result<AVIROOperationHoursDTO, APIError>
        ) -> Void) {
        guard let url = requestAPI.getOperationHours(placeId: placeId).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    // MARK: Edit Refer
    func editMenu(
        with menu: AVIROEditMenuModel,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>
        ) -> Void) {
        guard let url = postAPI.editMenu().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(menu) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func editPlaceLocation(
        with location: AVIROEditLocationDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.editPlaceLocation().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(location) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func editPlacePhone(
        with phone: AVIROEditPhoneDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.editPlacePhone().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(phone) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func editPlaceOperation(
        with operation: AVIROEditOperationTimeDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.editPlaceOperation().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(operation) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func editPlaceURL(
        with urlData: AVIROEditURLDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.editPlaceURL().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(urlData) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func editReview(
        with review: AVIROEditReviewDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.commentEdit().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(review) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    // MARK: Report Refer
    func reportReview(
        with review: AVIROReportReviewDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.commentReport().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(review) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func reportPlace(
        with place: AVIROReportPlaceDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.placeReport().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(place) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    // MARK: Delete Refer
    func deleteReview(
        with review: AVIRODeleteReveiwDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = deleteAPI.deleteComment(model: review).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .delete,
            headers: deleteAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    // MARK: User Refer
    func appleUserCheck(
        with user: AVIROAutoLoginWhenAppleUserDTO,
        completionHandler: @escaping (Result<AVIROAutoLoginWhenAppleUserResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.appleUserAutoLogin().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func checkWhenAppleLogin(
        with appleToken: AVIROAppleUserCheckMemberDTO,
        completionHandler: @escaping (Result<AVIROAppleUserCheckMemberResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.appleUserCheck().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(appleToken) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func createAppleUser(
        with user: AVIROAppleUserSignUpDTO,
        completionHandler: @escaping (Result<AVIROAutoLoginWhenAppleUserResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.appleUserSignup().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func revokeAppleUser(
        with user: AVIROAutoLoginWhenAppleUserDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.appleUserRevoke().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func checkNickname(
        with nickname: AVIRONicknameIsDuplicatedCheckDTO,
        completionHandler: @escaping (Result<AVIRONicknameIsDuplicatedCheckResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.nicknameCheck().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(nickname) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }
    
    func editNickname(
        with nickname: AVIRONicknameChagneableDTO,
        completionHandler: @escaping (Result<AVIROResultDTO, APIError>) -> Void
    ) {
        guard let url = postAPI.nicknameChange().url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(nickname) else {
            completionHandler(.failure(.encodingError))
            return
        }
        
        performRequest(
            with: url,
            httpMethod: .post,
            requestBody: jsonData,
            headers: postAPI.headers,
            completionHandler: completionHandler
        )
    }

    // MARK: My Page
    func loadMyContributedCount(
        with userId: String,
        completionHandler: @escaping (Result<AVIROMyContributionCountDTO, APIError>) -> Void
    ) {
        guard let url = requestAPI.getMyContributionCount(userId: userId).url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
}
