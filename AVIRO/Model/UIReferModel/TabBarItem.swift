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
        case .plus: return "제보하기"
        case .bookMark: return "북마크"
        case .myPage: return "마이페이지"
        }
    }
    
    var icon: (default: UIImage?, selected: UIImage?) {
        switch self {
        case .home: return (
            UIImage(systemName: "house.circle"),
            UIImage(systemName: "house.circle.fill")
        )
        case .popular: return (
            UIImage(named: "RecommendStore"),
            UIImage(named: "RecommendStore")
        )
        case .plus: return (
            UIImage(systemName: "plus.square"),
            UIImage(systemName: "plus.square.fill")
        )
        case .bookMark: return (
            UIImage(systemName: "book.closed.circle"),
            UIImage(systemName: "book.closed.circle.fill")
        )
        case .myPage: return (
            UIImage(systemName: "person.circle"),
            UIImage(systemName: "person.circle.fill")
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
