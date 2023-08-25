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
    case allMapStar
    case allMapStarClicked
    
    case someMap
    case someMapClicked
    case someMapStar
    case someMapStarClicked
    
    case requestMap
    case requestMapClicked
    case requestMapStar
    case requestMapStarClicked
    
    private static let allMapImage = NMFOverlayImage(name: "AllMap")
    private static let someMapImage = NMFOverlayImage(name: "SomeMap")
    private static let requestMapImage = NMFOverlayImage(name: "RequestMap")
    
    private static let allMapClickedImage = NMFOverlayImage(name: "AllMapClicked")
    private static let someMapClickedImage = NMFOverlayImage(name: "SomeMapClicked")
    private static let requestMapClickedImage = NMFOverlayImage(name: "RequestMapClicked")
    
    private static let allMapStarImage = NMFOverlayImage(name: "AllMapStar")
    private static let someMapStarImage = NMFOverlayImage(name: "SomeMapStar")
    private static let requestMapStarImage = NMFOverlayImage(name: "RequestMapStar")
    
    private static let allMapStarClickedImage = NMFOverlayImage(name: "AllMapStarClicked")
    private static let someMapStarClickedImage = NMFOverlayImage(name: "SomeMapStarClicked")
    private static let requestMapStarClickedImage = NMFOverlayImage(name: "RequestMapStarClicked")
    
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
            
        case .allMapStar:
            return MapIcon.allMapStarImage
        case .allMapStarClicked:
            return MapIcon.allMapStarClickedImage
            
        case .someMapStar:
            return MapIcon.someMapStarImage
        case .someMapStarClicked:
            return MapIcon.someMapStarClickedImage
            
        case .requestMapStar:
            return MapIcon.requestMapStarImage
        case .requestMapStarClicked:
            return MapIcon.requestMapStarClickedImage
        }
    }
}

struct MarkerModel {
    let placeId: String
    let marker: NMFMarker
    let mapPlace: MapPlace
    var isStar = false
    
    var isAll = false
    var isSome = false
    var isRequest = false
}
