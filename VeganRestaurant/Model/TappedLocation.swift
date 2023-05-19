//
//  PersonalLocation.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import Foundation


final class PersonalLocation {
    static let shared = PersonalLocation()
    
    var latitude: Double?
    var longtitude: Double?
    
    private init(latitude: Double? = nil, longtitude: Double? = nil) {
        self.latitude = latitude
        self.longtitude = longtitude
    }
}
