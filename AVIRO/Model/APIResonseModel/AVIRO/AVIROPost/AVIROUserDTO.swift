//
//  UserInfoModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/29.
//

import Foundation

// MARK: Gender 확인
enum Gender: String, Codable {
    case female
    case male
    case other
}

// MARK: 유저 정보 input
struct AVIROUserSignUpDTO: Codable {
    var userToken: String
    var userName: String?
    var userEmail: String?
    var nickname: String?
    var birthday: Int?
    var gender: String?
    var marketingAgree: Bool
}

// MARK: 유저 확인 Input
struct AVIROAppleUserCheckMemberDTO: Encodable {
    let userToken: String
}

// MARK: 유저 확인 output
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

// MARK: 닉네임 중복 확인 Input
struct AVIRONicknameIsDuplicatedCheckDTO: Encodable {
    let nickname: String
}

// MARK: 닉네임 중복 확인 Output
struct AVIROAfterNicknameIsDuplicatedCheckDTO: Codable {
    let statusCode: Int
    let isValid: Bool?
    let message: String
}

// MARK: 유저 탈퇴 Input
struct AVIROUserWithdrawDTO: Encodable {
    let userToken: String
}
