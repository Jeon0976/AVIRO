//
//  StaticImage.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

/// image data set 
struct Image {
    // MARK: Tutorial & Registration
    struct Registration {
        static let check = "bxs-check-circle.svg"
        static let xCheck = "bxs-error-alt.svg"
        static let logo = "Logo"
    }
    
    // MARK: TabBar Icon
    struct TabBar {
        static let bookmark1 = "bookmark1"
        static let bookmark2 = "bookmark2"
        static let edit1 = "edit1"
        static let edit2 = "edit2"
        static let map1 = "map1"
        static let map2 = "map2"
        static let star1 = "star1"
        static let star2 = "star2"
        static let user1 = "user1"
        static let user2 = "user2"
    }
    
    // MARK: Restaurant Detail
    static let call = "call"
    static let info = "info"
    static let map = "map"
    
    // MARK: ETC ICon
    static let bookmark = "Bookmark"
    static let close = "Close"
    static let comment = "comment"
    static let PersonalLocation = "PersonalLocation"
    static let search = "Search"
    static let share = "share"
    
    static let bigGilraim = "bigGilraim"
    
    // MARK: HomeInfo
    static let homeInfoRequestVegan = "HomeInfoRequestVegan"
    static let homeInfoRequestVeganTitle = "HomeInfoRequestVeganTitle"
    static let homeInfoSomeVegan = "HomeInfoSomeVegan"
    static let homeInfoSomeVeganTitle = "HomeInfoSomeVeganTitle"
    static let homeInfoVegan = "HomeInfoVegan"
    static let homeInfoVeganTitle = "HomeInfoVeganTitle"
    
    // MARK: Location Marker
    static let inrollSearchIcon = "InrollSearchIcon"
    static let allVegan = "allVegan"
    static let requestVegan = "requestVegan"
    static let someMenuVegan = "someMenuVegan"

    // MARK: Inroll View Image
    struct InrollView {
        static let plusButton = "plusButton"
        static let allVeganSelected = "올비건"
        static let allVeganNoSelected = "올비건No"
        static let someMenuVeganSelected = "썸비건"
        static let someMenuVeganNoSelected = "썸비건No"
        static let requestMenuVeganSelected = "요청비건"
        static let requestMenuVeganNoSelected = "요청비건No"
        
        static let checkImage = UIImage(systemName: "checkmark")
    }
}
