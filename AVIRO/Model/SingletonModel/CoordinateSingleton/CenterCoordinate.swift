//
//  CenterCoordinate.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/07.
//

import Foundation

/// 경도(x:Longitude) 위도(y:latitude)
final class CenterCoordinate {
    static let shared = CenterCoordinate()
    
    var latitude: Double? {
        didSet {
            coordinateChanged?()
        }
    }
    
    var longitude: Double? {
        didSet {
            coordinateChanged?()
        }
    }
    
    var latitudeString: String {
        return String(format: "%.5f", latitude ?? "")
    }
    
    var longitudeString: String {
        return String(format: "%.5f", longitude ?? "")
    }
    
    var coordinateChanged: (() -> Void)?
    
    private init(latitude: Double? = nil,
                 longitude: Double? = nil
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
