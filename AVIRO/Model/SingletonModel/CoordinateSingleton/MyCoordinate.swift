//
//  PersonalLocation.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

/// 경도(x:Longitude) 위도(y:latitude)
final class MyCoordinate {
    static let shared = MyCoordinate()
    
    var latitude: Double?
    var longitude: Double?
    
    var latitudeString: String {
        return String(format: "%.5f", latitude ?? "")
    }
    
    var longitudeString: String {
        return String(format: "%.5f", longitude ?? "")
    }
    
    private init(latitude: Double? = nil,
                 longitude: Double? = nil
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
