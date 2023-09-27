//
//  AVIROAPIManagerProtocol.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/26.
//

import Foundation

protocol AVIROAPIMangerProtocol: APIManagerProtocol {
    // MARK: Marker Refer
    func loadNerbyPlaceModels(
        with mapModel: AVIROMapModelDTO,
        completionHandler: @escaping(Result<AVIROMapModelResultDTO, APIError>) -> Void
    )
    func loadBookmarkModels(
        with userId: String,
        completionHandler: @escaping(Result<AVIROBookmarkModelResultDTO, APIError>) -> Void
    )
    func createBookmarkModel(
        with bookmarkModel: AVIROUpdateBookmarkDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    
    // MARK: Check Refer
    func checkPlaceOne(
        with placeModel: AVIROCheckPlaceDTO,
        completionHandler: @escaping(Result<AVIROCheckPlaceResultDTO, APIError>) -> Void
    )
    func checkPlaceList(
        with placeArray: AVIROBeforeComparePlaceDTO,
        completionHandler: @escaping(Result<AVIROAfterComparePlaceDTO, APIError>) -> Void
    )
    func checkPlaceReportIsDuplicated(
        with checkReportModel: AVIROPlaceReportCheckDTO,
        completionHandler: @escaping(Result<AVIROPlaceReportCheckResultDTO, APIError>) -> Void
    )
    
    // MARK: Create Refer
    func createPlaceModel(
        with placeModel: AVIROEnrollPlaceDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    func createReview(
        with reviewModel: AVIROEnrollReviewDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    
    // MARK: Load Refer
    func loadPlaceSummary(
        with placeId: String,
        completionHandler: @escaping(Result<AVIROSummaryResultDTO, APIError>) -> Void
    )
    func loadPlaceInfo(
        with placeId: String,
        completionHandler: @escaping(Result<AVIROPlaceInfoResultDTO, APIError>) -> Void
    )
    func loadMenus(
        with placeId: String,
        completionHandler: @escaping(Result<AVIROMenusResultDTO, APIError>) -> Void
    )
    func loadReviews(
        with placeId: String,
        completionHandler: @escaping(Result<AVIROReviewsResultDTO, APIError>) -> Void
    )
    func loadOperationHours(
        with placeId: String,
        completionHandler: @escaping(Result<AVIROOperationHoursDTO, APIError>) -> Void
    )
    
    // MARK: Edit Refer
    func editMenu(
        with menu: AVIROEditMenuModel,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    func editPlaceLocation(
        with location: AVIROEditLocationDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    func editPlacePhone(
        with phone: AVIROEditPhoneDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    func editPlaceOperation(
        with operation: AVIROEditOperationTimeDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    func editPlaceURL(
        with url: AVIROEditURLDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    func editReview(
        with review: AVIROEditReviewDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    
    // MARK: Report Refer
    func reportReview(
        with review: AVIROReportReviewDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    func reportPlace(
        with place: AVIROReportPlaceDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    
    // MARK: Delete Refer
    func deleteReview(
        with review: AVIRODeleteReveiwDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )

    // MARK: User Refer
    func checkUserId(
        with user: AVIROCheckUserDTO,
        completionHandler: @escaping(Result<AVIROCheckUserResultDTO, APIError>) -> Void
    )
    func checkAppleToken(
        with appleToken: AVIROAppleUserCheckMemberDTO,
        completionHandler: @escaping(Result<AVIROCheckUserResultDTO, APIError>) -> Void
    )
    
    func createUser(
        with user: AVIROUserSignUpDTO,
        completionHandler: @escaping(Result<AVIROUserSignUpResultDTO, APIError>) -> Void
    )
    func withdrawalUser(
        with user: AVIROUserWithdrawDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )

    func checkNickname(
        with nickname: AVIRONicknameIsDuplicatedCheckDTO,
        completionHandler: @escaping(Result<AVIRONicknameIsDuplicatedCheckResultDTO, APIError>) -> Void
    )
    func editNickname(
        with nickname: AVIRONicknameChagneableDTO,
        completionHandler: @escaping(Result<AVIROResultDTO, APIError>) -> Void
    )
    
    // MARK: My Page
    func loadMyContributedCount(
        with userId: String,
        completionHandler: @escaping(Result<AVIROMyContributionCountDTO, APIError>) -> Void
    )
}
