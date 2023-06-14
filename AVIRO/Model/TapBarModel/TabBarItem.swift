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
        case .home: return StaticStringValue.home
        case .popular: return StaticStringValue.popular
        case .plus: return ""
        case .bookMark: return StaticStringValue.bookmark
        case .myPage: return StaticStringValue.myPage
        }
    }
    
    var icon: (default: UIImage?, selected: UIImage?) {
        switch self {
        case .home: return (
            UIImage(named: StaticImage.map1),
            UIImage(named: StaticImage.map2)
            )
        case .popular: return (
            UIImage(named: StaticImage.star1),
            UIImage(named: StaticImage.star2)
            )
        case .plus: return (
            nil,
            nil
            )
        case .bookMark: return (
            UIImage(named: StaticImage.bookmark1),
            UIImage(named: StaticImage.bookmark2)
            )
        case .myPage: return (
            UIImage(named: StaticImage.user1),
            UIImage(named: StaticImage.user2)
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
