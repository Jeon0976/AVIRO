//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import UIKit

import NMapsMap

enum MapPlace {
    case All
    case Some
    case Request
}

enum MapIcon {
    case allMap
    case allMapClicked
    case someMap
    case someMapClicked
    case requestMap
    case requestMapClicked
    
    private static let allMapImage = NMFOverlayImage(name: "AllMap")
    private static let someMapImage = NMFOverlayImage(name: "SomeMap")
    private static let requestMapImage = NMFOverlayImage(name: "RequestMap")
    private static let allMapClickedImage = NMFOverlayImage(name: "AllMapClicked")
    private static let someMapClickedImage = NMFOverlayImage(name: "SomeMapClicked")
    private static let requestMapClickedImage = NMFOverlayImage(name: "RequestMapClicked")
    
    var image: NMFOverlayImage {
        switch self {
        case .allMap:
            return MapIcon.allMapImage
        case .allMapClicked:
            return MapIcon.allMapClickedImage
        case .someMap:
            return MapIcon.someMapImage
        case .someMapClicked:
            return MapIcon.someMapClickedImage
        case .requestMap:
            return MapIcon.requestMapImage
        case .requestMapClicked:
            return MapIcon.requestMapClickedImage
        }
    }
}

struct MarkerModel {
    let placeId: String
    let marker: NMFMarker
    let mapPlace: MapPlace
    var isSelected: Bool
    var isStar: Bool?
}
