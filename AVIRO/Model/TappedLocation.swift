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
    var longitude: Double?
    
    private init(latitude: Double? = nil, longitude: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
