//
//  LocationUtility.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/13.
//

import UIKit

final class LocationUtility {
    /// 내 위치로부터 얼마나 떨어져있는지 확인 하는 함수
   static func distanceMyLocation(
    x_lng: Double,
    y_lat: Double
   ) -> Double {
        guard let latitude = MyCoordinate.shared.latitude,
              let longitude = MyCoordinate.shared.longitude else {
            let calculatedDistance = distanceBetweenPoints(
                lat1: DefaultCoordinate.lat.rawValue,
                lon1: DefaultCoordinate.lng.rawValue,
                lat2: y_lat,
                lon2: x_lng
            )
            return calculatedDistance
        }
       
        /// 소수점 조정을 위한 곱하기 1000
        let calculatedDistance = distanceBetweenPoints(
            lat1: latitude,
            lon1: longitude,
            lat2: y_lat,
            lon2: x_lng
        ) * 1000
       
        return calculatedDistance
    }
    
    /// 하버사인 공식 활용
   static private func distanceBetweenPoints(
    lat1: Double,
    lon1: Double,
    lat2: Double,
    lon2: Double
   ) -> Double {
        // 지구의 평균 반경(km)
        let R = 6371.0
        
        let dLat = (lat2 - lat1).degreesToRadians
        let dLon = (lon2 - lon1).degreesToRadians
        let sinMuti = sin(dLat/2) * sin(dLat/2)
        let cocosinsin = cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) * sin(dLon/2) * sin(dLon/2)
        
        let a = sinMuti + cocosinsin
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        return R * c
    }
}
