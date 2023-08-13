//
//  AVIROPlaceModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROPlaceModel: Decodable {
    let statusCode: Int
    let data: PlaceData
}

struct PlaceData: Decodable {
    let placeId: String
    let title: String
    let category: String
    let address: String
    let phone: String
    let url: String
    
    let x: Double
    let y: Double
        
    let allVegan: Bool
    let someMenuVegan: Bool
    let ifRequestVegan: Bool
    
    let commentCount: Int
}
