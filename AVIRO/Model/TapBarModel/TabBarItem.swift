//
//  TabBarItem.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit

enum TabBarItem: CaseIterable {
    case home
    case popular
    case plus
    case bookMark
    case myPage
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .popular: return "인기가게"
        case .plus: return ""
        case .bookMark: return "북마크"
        case .myPage: return "마이페이지"
        }
    }
    
    var icon: (default: UIImage?, selected: UIImage?) {
        switch self {
        case .home: return (
            UIImage(named: "map1"),
            UIImage(named: "map2")
        )
        case .popular: return (
            UIImage(named: "star1"),
            UIImage(named: "star2")
        )
        case .plus: return (
            nil,
            nil
//            UIImage(named: "edit1"),
//            UIImage(named: "edit2")
        )
        case .bookMark: return (
            UIImage(named: "bookmark1"),
            UIImage(named: "bookmark2")
        )
        case .myPage: return (
            UIImage(named: "user1"),
            UIImage(named: "user2")
        )
            
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home: return UINavigationController(rootViewController: HomeViewController())
        case .popular: return UINavigationController(rootViewController: PopularViewController())
        case .plus: return UINavigationController(rootViewController: InrollPlaceViewController())
        case .bookMark: return UINavigationController(rootViewController: BookMarkViewController())
        case .myPage: return UINavigationController(rootViewController: MyPageViewController())
        }
    }
}
