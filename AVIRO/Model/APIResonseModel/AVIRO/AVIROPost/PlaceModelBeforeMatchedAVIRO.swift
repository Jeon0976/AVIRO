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
    let allVegan: Bool
    let someMenuVegan: Bool
    let ifRequestVegan: Bool
}
