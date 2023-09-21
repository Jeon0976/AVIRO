//
//  UserInfoModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/29.
//

import Foundation

struct AVIROUserSignUpDTO: Codable {
    var userToken: String
    var userName: String?
    var userEmail: String?
    var nickname: String?
    var birthday: Int?
    var gender: String?
    var marketingAgree: Bool
}

struct AVIROAppleUserCheckMemberDTO: Encodable {
    let userToken: String
}

struct AVIROAfterAppleUserCheckMemberDTO: Codable {
    let statusCode: Int
    let data: AVIROAppleUserDataDTO?
    let message: String?
}

struct AVIROAppleUserDataDTO: Codable {
    let userId: String
    let userName: String
    let userEmail: String
    let nickname: String
    let marketingAgree: Int
}

struct AVIRONicknameIsDuplicatedCheckDTO: Encodable {
    let nickname: String
}

struct AVIRONicknameIsDuplicatedCheckResultDTO: Codable {
    let statusCode: Int
    let isValid: Bool?
    let message: String
}

struct AVIRONicknameChagneableDTO: Encodable {
    let userId: String
    let nickname: String
}

struct AVIROUserWithdrawDTO: Encodable {
    let userToken: String
}
