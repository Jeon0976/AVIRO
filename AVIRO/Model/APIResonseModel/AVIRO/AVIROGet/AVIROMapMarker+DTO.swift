//
//  AVIROMapModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct AVIROMapModelDTO {
    let longitude: String
    let latitude: String
    let wide: String
    let time: String?
}

struct AVIROMapModelResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROMapModelResultDataDTO
}

struct AVIROMapModelResultDataDTO: Decodable {
    let amount: Int
    let deletedPlace: [String]?
    let updatedPlace: [AVIROMarkerModel]?
}

// MARK: 관련 로직 확인해보기
// TODO: 2
struct AVIROMarkerModel: Decodable {
    let placeId: String
    let x: Double
    let y: Double
    let allVegan: Bool
    let someMenuVegan: Bool
    let ifRequestVegan: Bool
}
