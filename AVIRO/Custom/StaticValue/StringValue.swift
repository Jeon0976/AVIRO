//
//  StaticStringValue.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import Foundation

/// String data set
struct StringValue {
    // MARK: Tab bar
    struct TabBar {
        static let home = "홈"
        static let popular = "인기가게"
        static let plus = "제보하기"
        static let bookmark = "북마크"
        static let myPage = "마이페이지"
    }
    
    // MARK: Home View
    struct HomeView {
        static let searchPlaceHolder = "점심으로 비건식 어떠세요?"
        static let share = "공유하기"
        static let bookmark = "북마크   "
        static let comments = "댓글     "
        static let reportButton = "비건 식당 제보하러가기"
    }
    
    struct InrollView {
        static let naviTitle = "가게 제보하기"
        static let naviRightBar = "제보하기"
        static let reportButton = "이 가게 제보하기"
        
        static let required = "(필수)"
        static let optional = "(선택)"
        
        static let storeTitle = "가게 이름"
        static let storeTitlePlaceHolder = "가게를 찾아보세요"
        static let storeLocation = "가게 위치"
        static let storeCategory = "카테고리"
        static let storePhone = "전화번호"
        static let storeTypes = "가게 종류"
        
        static let allVegan = "ALL 비건"
        static let someVegan = "비건 메뉴 포함"
        static let requestVegan = "요청하면 비건"
        
        static let menuTable = "메뉴 등록하기"
    }
}
