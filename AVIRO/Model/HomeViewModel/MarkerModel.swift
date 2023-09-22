//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import UIKit

import NMapsMap

// MARK: Map Place didSet 수정 확인
struct MarkerModel {
    let placeId: String
    let marker: NMFMarker
    // MARK: 수정 중 일때만 Map Place 변경 가능 
    var mapPlace: MapPlace {
        didSet {
            if isStar {
                marker.changeStarIcon(mapPlace, true)
            } else {
                marker.changeIcon(mapPlace, true)
            }
        }
    }
    
    var isStar = false {
        didSet {
            if isStar {
                marker.changeStarIcon(mapPlace, isCliced)
            } else {
                marker.changeIcon(mapPlace, isCliced)
            }
        }
    }
    
    var isCliced = false {
        didSet {
            if isStar {
                marker.changeStarIcon(mapPlace, isCliced)
            } else {
                marker.changeIcon(mapPlace, isCliced)
            }
        }
    }
    
    var isAll = false
    var isSome = false
    var isRequest = false
}
