//
//  HomeMapData.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct HomeMapData: Decodable {
    let placeId: String
    let x: Double
    let y: Double
    let title: String
    let address: String

    let allVegan: Bool
    let someMenuVegan: Bool
    let ifRequestVegan: Bool
}
