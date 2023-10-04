//
//  DefaultEnum.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/20.
//

import UIKit

import NMapsMap

enum APP: String {
    case appId = "6449352804"
}

// MARK: Emplitude
enum AMType: String {
    case signUp = "Sign Up"
    case withdrawal = "Withdrawal"
    
    case login = "Login"
    case logout = "Logout"
    
    case requestPlaceInfo = "Request to Edit Place Info"
    
    case searchHSV = "Search In HomeSearchView"
    
    case popupPlace = "Pop Up"
    
    case afterUploadPlace = "Upload Place"
    case afterUploadReview = "Upload Review"
    case afterEditMenu = "Edit Menu Table"
}

// MARK: UserDefaults Key
enum UDKey: String {
    case tutorial
    case matchedPlaceModel
}

// MARK: Keychain
enum KeychainKey: String {
    case appleRefreshToken
}

// MARK: TableViewCell Identifier
enum TVIdentifier: String {
    case termsTableCell
}

// MARK: CollectionViewCell Identifier
enum CVIdentifier: String {
    case test
}

// MARK: 이용 약관
enum Policy: String {
    case termsOfService = "https://sponge-nose-882.notion.site/259b51ac0b4a41d7aaf5ea2b89a768f8?pvs=4"
    case privacy = "https://sponge-nose-882.notion.site/c98c9103ebdb44cfadd8cd1d11600f99?pvs=4"
    case location =  "https://sponge-nose-882.notion.site/50102bd385664c89ab39f1b290fb033e?pvs=4"
    case thanksto = "https://sponge-nose-882.notion.site/8bfc56f574f542648a2d95c938e2f96f"
}

// MARK: Defalut Coordinate
/// 광안리 해수욕장
enum DefaultCoordinate: Double {
    case lat = 35.153354
    case lng = 129.118924
}

// MARK: TabBar
/// TabBarItem Enum
enum TBItem: CaseIterable {
    case home
    case plus
    case myPage
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .plus: return "등록하기"
        case .myPage: return "마이페이지"
        }
    }
    
    var icon: (
        default: UIImage?,
        selected: UIImage?
    ) {
        switch self {
        case .home: return (
            UIImage.home1,
            UIImage.home2
            )

        case .plus: return (
            UIImage.edit1,
            UIImage.edit2
            )

        case .myPage: return (
            UIImage.user1,
            UIImage.user2
            )
        }
    }
    
    var vc: UIViewController {
        switch self {
        case .home: return UINavigationController(
            rootViewController: HomeViewController()
        )
        case .plus: return UINavigationController(
            rootViewController: EnrollPlaceViewController()
        )
        case .myPage: return UINavigationController(
            rootViewController: MyPageViewController()
        )
        }
    }
}

// MARK: Gender 
enum Gender: String, Codable {
    case male
    case female
    case other
    
    init?(rawValue: String) {
        switch rawValue {
        case "남자":
            self = .male
        case "여자":
            self = .female
        case "기타":
            self = .other
        default:
            return nil
        }
    }
}

// MARK: Map Marker
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
    
    private static let allMapImage = NMFOverlayImage(image: .allIcon)
    private static let someMapImage = NMFOverlayImage(image: .someIcon)
    private static let requestMapImage = NMFOverlayImage(image: .requestIcon)
    
    private static let allMapClickedImage = NMFOverlayImage(image: .allIconClicked)
    private static let someMapClickedImage = NMFOverlayImage(image: .someIconClicked)
    private static let requestMapClickedImage = NMFOverlayImage(image: .requestIconClicked)
    
    private static let allMapStarImage = NMFOverlayImage(image: .allIconStar)
    private static let someMapStarImage = NMFOverlayImage(image: .someIconStar)
    private static let requestMapStarImage = NMFOverlayImage(image: .requestIconStar)
    
    private static let allMapStarClickedImage = NMFOverlayImage(image: .allIconStarClicked)
    private static let someMapStarClickedImage = NMFOverlayImage(image: .someIconStarClicked)
    private static let requestMapStarClickedImage = NMFOverlayImage(image: .requestIconStarClicked)
    
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

// MARK: Vegan Option
enum VeganOption {
    case all
    case some
    case request
    
    var buttontitle: String {
        switch self {
        case .all:
            return "모든 메뉴가\n비건"
        case .some:
            return "일부 메뉴만\n비건"
        case .request:
            return "비건 메뉴로\n요청 가능"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .all:
            return UIImage.allOptionButton
        case .some:
            return UIImage.someOptionButton
        case .request:
            return UIImage.requestOptionButton
        }
    }
}

// MARK: Place Category
enum PlaceCategory: String {
    case restaurant
    case cafe
    case bakery
    case bar
    
    var title: String {
        switch self {
        case .restaurant: return "식당"
        case .cafe: return "카페"
        case .bakery: return "빵집"
        case .bar: return "술집"
        }
    }
    
    init?(title: String) {
        switch title {
        case "식당": self = .restaurant
        case "카페": self = .cafe
        case "빵집": self = .bakery
        case "술집": self = .bar
        default: return nil
        }
    }
}

// MARK: MenuType
enum MenuType: String {
    case vegan
    case needToRequset
}

// MARK: Operation State
enum OperationState: String {
    case beforeOpening = "영업전"
    case operating = "영업중"
    case closed = "영업종료"
    case breakTime = "휴식시간"
    case holiday = "휴무일"
    case noInfoToday = "오늘 정보 없음"
    
    var color: UIColor {
        switch self {
        case .breakTime, .holiday:
            return .warning
        case .noInfoToday:
            return .gray2
        default:
            return .gray0
        }
    }
}

// MARK: Day
enum Day: String {
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fri = "금"
    case sat = "토"
    case sun = "일"
}

// MARK: Place View State
enum PlaceViewState {
    case noShow
    case popup
    case slideup
    case full
}

// MARK: Report Place
enum AVIROReportPlaceType: String {
    case noPlace = "없어짐"
    case noVegan = "비건없음"
    case dubplicatedPlace = "중복등록"
    
    var code: Int {
        switch self {
        case .noPlace:
            return 1
        case .noVegan:
            return 2
        case .dubplicatedPlace:
            return 3
        }
    }
}

// MARK: Report Review Type
enum AVIROReportReviewType: String, CaseIterable {
    case profanity = "욕설/비방/차별/혐오 후기예요."
    case advertisement = "홍보/영리목적 후기예요."
    case illegalInfo = "불법 정보 후기예요."
    case obscene = "음란/청소년 유해 후기예요."
    case personalInfo = "개인 정보 노출/유포/거래를 한 후기예요."
    case spam = "도배/스팸 후기예요."
    case others = "기타"
    
    var code: Int {
        switch self {
        case .profanity:
            return 1
        case .advertisement:
            return 2
        case .illegalInfo:
            return 3
        case .obscene:
            return 4
        case .personalInfo:
            return 5
        case .spam:
            return 6
        case .others:
            return 7
        }
    }
}
