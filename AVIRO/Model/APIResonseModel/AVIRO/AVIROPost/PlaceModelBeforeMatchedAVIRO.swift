//
//  PlaceModelBeforeMatchedAVIRO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/05.
//

import Foundation

// MARK: Request
struct PlaceModelBeforeMatchedAVIRO: Encodable {
    let placeArray: [ForMatchedAVIRO]
}

struct ForMatchedAVIRO: Encodable {
    let title: String
    let address: String
    let x: Double
    let y: Double
}

// MARK: Response
struct PlaceModelAfterMatchedAVIRO: Decodable {
    let statusCode: Int
    let body: [AfterMatchedAVIRO]
}

struct AfterMatchedAVIRO: Decodable {
    let index: Int
    let allVegan: Int
    let someMenuVegan: Int
    let ifRequestVegan: Int
}
