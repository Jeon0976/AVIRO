//
//  TabBarItem.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit

// TODO: 추후 수정 예정
enum TabBarItem: CaseIterable {
    case home
//    case popular
    case plus
//    case bookMark
    case myPage
    
    var title: String {
        switch self {
        case .home: return StringValue.TabBar.home
//        case .popular: return StringValue.TabBar.popular
        case .plus: return ""
//        case .bookMark: return StringValue.TabBar.bookmark
        case .myPage: return StringValue.TabBar.myPage
        }
    }
    
    var icon: (default: UIImage?, selected: UIImage?) {
        switch self {
        case .home: return (
            UIImage(named: Image.TabBar.map1),
            UIImage(named: Image.TabBar.map2)
            )
//        case .popular: return (
//            UIImage(named: Image.TabBar.star1),
//            UIImage(named: Image.TabBar.star2)
//            )
        case .plus: return (
            nil,
            nil
            )
//        case .bookMark: return (
//            UIImage(named: Image.TabBar.bookmark1),
//            UIImage(named: Image.TabBar.bookmark2)
//            )
        case .myPage: return (
            UIImage(named: Image.TabBar.user1),
            UIImage(named: Image.TabBar.user2)
            )
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home: return UINavigationController(rootViewController: HomeViewController())
//        case .popular: return UINavigationController(rootViewController: PopularViewController())
        case .plus: return UINavigationController(rootViewController: InrollPlaceViewController())
//        case .bookMark: return UINavigationController(rootViewController: InrollPlaceViewController2())
        case .myPage: return UINavigationController(rootViewController: MyPageViewController())
        }
    }
}
