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
    case plus
    case myPage
    
    var title: String {
        switch self {
        case .home: return StringValue.TabBar.home
        case .plus: return ""
        case .myPage: return StringValue.TabBar.myPage
        }
    }
    
    var icon: (default: UIImage?, selected: UIImage?) {
        switch self {
        case .home: return (
            UIImage(named: "map1"),
            UIImage(named: "map2")
            )

        case .plus: return (
            nil,
            nil
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
        case .plus: return UINavigationController(rootViewController: InrollPlaceViewController())
        case .myPage: return UINavigationController(rootViewController: MyPageViewController())
        }
    }
}
