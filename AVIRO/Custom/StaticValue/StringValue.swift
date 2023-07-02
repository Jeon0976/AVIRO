//
//  StaticStringValue.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import Foundation

/// String data set
struct StringValue {
    // MARK: Login View
    struct Login {
        static let apple = "애플로 로그인"
        static let noLogin = "로그인 없이 둘러보기"
    }
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
    
    // MARK: Home Search View
    struct HomeSearchView {
        static let naviTitle = "검색 결과"
        static let searchPlaceHolder = "가게 이름을 검색해보세요"
    }
    
    // MARK: Detail View
    struct DetailView {
        static let storeInfoTitle = "식당 정보"
        static let menuInfoTitle = "메뉴 정보"
        static let commentInfoTitle = "댓글"
        
        static let requestDelete = "식당 정보 오류 및 삭제 요청"
        static let commentCount = "개"
        
        static let noInfo = "정보가 없습니다"
        static let noMenuInfo = "등록된 메뉴가 없어요"
        static let noMenuDetail = "식당 정보 오류 및 삭제 요청을 통해 등록해주세요"
        static let noCommentInfo = "아직 댓글이 없어요"
        static let noCommentDetail = "영광스러운 첫 댓글을 남겨주세요"
        
        static let commentButton = "나도 댓글 달기"
    }
    
    // MARK: Comment View
    struct CommentView {
        static let commentPlaceHolder = "이 식당에 대한 경험을 적어주세요!"
        static let reportButton = "게시"
    }
    
    
    // MARK: Inroll View
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
        
        static let menuPlaceHolder = "메뉴"
        static let pricePlaceHolder = "가격"
        static let requestButtonTitle = "요청"
        static let detailPlaceHolder = "예. 비비밥에 달걀 빼주세요."
    }
    
    // MARK: Place List Search View
    struct PlaceListView {
        static let naviTitle = "가게 이름 검색"
        static let searchFieldPlaceHolder = "가게 이름을 검색해보세요"
    }
}
