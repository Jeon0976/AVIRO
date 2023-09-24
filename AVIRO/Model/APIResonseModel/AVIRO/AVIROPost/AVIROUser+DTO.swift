//
//  UserInfoModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/29.
//

import Foundation

struct AVIROUserCheckDTO: Encodable {
    let userId: String
}

struct AIVROUserCheckResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROUserDataDTO?
    let message: String?
}

struct AVIROAppleUserCheckMemberDTO: Encodable {
    let userToken: String
}

struct AVIROUserDataDTO: Codable {
    let userId: String
    let userName: String
    let userEmail: String
    let nickname: String
    let marketingAgree: Int
}

struct AVIROUserSignUpDTO: Codable {
    var userToken: String
    var userName: String?
    var userEmail: String?
    var nickname: String?
    var birthday: Int?
    var gender: String?
    var marketingAgree: Bool
}

struct AVIROUserSignUpResultDTO: Decodable {
    let statusCode: Int
    let userId: String?
    let message: String?
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
    let userId: String
}
