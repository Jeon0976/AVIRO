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
    let message: String?
}

struct AVIROMapModelResultDataDTO: Decodable {
    let amount: Int
    let deletedPlace: [String]?
    let updatedPlace: [AVIROMarkerModel]?
}

// MARK: 관련 로직 확인해보기
// TODO: 2
struct AVIROMarkerModel: Codable, Hashable {
    let placeId: String
    let x: Double
    let y: Double
    let allVegan: Bool
    let someMenuVegan: Bool
    let ifRequestVegan: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(placeId)
    }
    
    static func ==(lhs: AVIROMarkerModel, rhs: AVIROMarkerModel) -> Bool {
        return lhs.placeId == rhs.placeId
    }
}
