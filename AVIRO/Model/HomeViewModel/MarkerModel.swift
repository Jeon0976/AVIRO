//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import UIKit

import NMapsMap

// MARK: Map Place didSet 수정 확인
struct MarkerModel: Equatable {
    let placeId: String
    var marker: NMFMarker
    
    // MARK: 수정 중 일때만 Map Place 변경 가능
    // 해당 변수는 지도에 표시될 마커 구분을 위한 변수
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
                marker.changeStarIcon(mapPlace, isClicked)
            } else {
                marker.changeIcon(mapPlace, isClicked)
            }
        }
    }
    
    var isClicked = false {
        didSet {
            if isStar {
                marker.changeStarIcon(mapPlace, isClicked)
            } else {
                marker.changeIcon(mapPlace, isClicked)
            }
        }
    }
    
    // edit할때 isSome, isRequest 중복이 있을 수 있으니 변수 생성
    var isAll = false
    var isSome = false
    var isRequest = false
}
