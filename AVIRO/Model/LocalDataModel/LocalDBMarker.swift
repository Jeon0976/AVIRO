//
//  LocalDBMarker.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/10/11.
//

import Foundation

import RealmSwift

final class MarkerModelFromRealm: Object {
    @Persisted(primaryKey: true) var placeId: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    @Persisted var isAll: Bool
    @Persisted var isSome: Bool
    @Persisted var isRequest: Bool
    
    // primary key 설정으로 convenince init 설정
    convenience init(
        placeId: String,
        latitude: Double,
        longitude: Double,
        isAll: Bool,
        isSome: Bool,
        isRequest: Bool
    ) {
        self.init()
        
        self.placeId = placeId
        self.latitude = latitude
        self.longitude = longitude
        self.isAll = isAll
        self.isSome = isSome
        self.isRequest = isRequest
    }
    
    func toAVIROMarkerModel() -> AVIROMarkerModel {
        return AVIROMarkerModel(
            placeId: placeId,
            x: longitude,
            y: latitude,
            allVegan: isAll,
            someMenuVegan: isSome,
            ifRequestVegan: isRequest
        )
    }
}
