//
//  PlaceListCellModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

/// API 요청 후 받고 나서 생기는 근간이 되는 데이터
struct PlaceListModel: Codable, Equatable {
    static func == (lhs: PlaceListModel, rhs: PlaceListModel) -> Bool {
        return lhs.title == rhs.title
    }

    let title: String
    let distance: String
    let category: String
    let address: String
    let phone: String
    let url: String
    let x: Double
    let y: Double
    
    var distanceMyLocation: Double {
        guard let latitude = PersonalLocation.shared.latitude,
              let longitude = PersonalLocation.shared.longitude else {
            let calculatedDistance = distanceBetweenPoints(lat1: 35.153354, lon1: 129.118924, lat2: y, lon2: x)
            return calculatedDistance
        }
        let calculatedDistance = distanceBetweenPoints(lat1: latitude, lon1: longitude, lat2: y, lon2: x)
        return calculatedDistance
    }
}

// 하버사인 공식 활용
func distanceBetweenPoints(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
    let R = 6371.0 // 지구의 평균 반경(km)
    let dLat = (lat2 - lat1).degreesToRadians
    let dLon = (lon2 - lon1).degreesToRadians
    let a = sin(dLat/2) * sin(dLat/2) + cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) * sin(dLon/2) * sin(dLon/2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))
    return R * c
}

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
}
