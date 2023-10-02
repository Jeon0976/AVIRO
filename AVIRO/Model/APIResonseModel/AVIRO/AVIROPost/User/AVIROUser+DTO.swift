//
//  UserInfoModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/29.
//

import Foundation

struct AVIROAutoLoginWhenAppleUserDTO: Encodable {
    let refreshToken: String
}

struct AVIROAutoLoginWhenAppleUserResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROUserDataDTO?
    let message: String?
}

struct AVIROUserDataDTO: Codable {
    let userId: String
    let userName: String
    let userEmail: String
    let nickname: String
    let marketingAgree: Int
}

struct AVIROAppleUserCheckMemberDTO: Encodable {
    let identityToken: String
    let authorizationCode: String
}

struct AVIROAppleUserCheckMemberResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROAppleUserRawData?
    let message: String?
}

struct AVIROAppleUserRawData: Decodable {
    let isMember: Bool
    let refreshToken: String
    let accessToken: String
    let userId: String
}

struct AVIROAppleUserSignUpDTO: Codable {
    let refreshToken: String
    let accessToken: String
    let userId: String
    var userName: String?
    var userEmail: String?
    var nickname: String?
    var birthday: Int?
    var gender: String?
    var marketingAgree: Bool?
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
