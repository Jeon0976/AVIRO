//
//  MockData.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/28.
//

import Foundation

final class Mock {
    let userDefaults: UserDefaultsManagerProtocol?
    
    init ( userDefaults: UserDefaultsManagerProtocol? = UserDefalutsManager()) {
        self.userDefaults = userDefaults
    }
    
    func make() {
        let firstPlcae = PlaceListModel(
            title: "러브얼스", distance: "1", category: "음식점 > 퓨전요리 > 퓨전한식", address: "부산 수영구 광안로49번길 32-1", phone: "070-4647-2420", url: "1", x: 129.11856, y: 35.1564)
        let firstComment = [
            CommentModel(comment: "대한민국 최고 비건 맛집.", date: .now),
            CommentModel(comment: "5주에 한 번씩 메뉴가 바뀐대요~", date: .now),
            CommentModel(comment: "비건 아닌 친구들 데려가도 필승하는 곳👍", date: .now),
            CommentModel(comment: "여기 오려고 부산 여행왔는데 후회 없어요.. 감동의 맛", date: .now),
        ]
        let firstNot = [
            NotRequestMenu(menu: "토마토 두부 덮밥", price: "13000"),
            NotRequestMenu(menu: "썸머 오리엔탈 우동 샐러드", price: "13000"),
            NotRequestMenu(menu: "베리 나나 스무디", price: "13000")
        ]
        let firstRe = RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false)
        
        let firstData = VeganModel(
            placeModel: firstPlcae, allVegan: true, someMenuVegan: false, ifRequestVegan: false, notRequestMenuArray: firstNot, requestMenuArray: [firstRe], comment: firstComment)
        
        let secondPlace = PlaceListModel(
            title: "꿀꺽하우스", distance: "1", category: "음식점 > 한식", address: "부산광역시 수영구 광남로 184-1 2층", phone: "050-714-860427", url: "1", x: 129.120075531004, y: 35.1571679326572)
        let secondComment = [
            CommentModel(comment: "분위기 맛집 술 맛집 비건 프렌들리까지!", date: .now),
            CommentModel(comment: "비건 안주중에 야채구이 없어지고 콜리플라워 구이로 바꼈어요", date: .now),
            CommentModel(comment: "참타리튀김+막걸리 조합 강추!", date: .now),
            CommentModel(comment: "막걸리는 꿀만 피하면 다 비건인 것 같아요~", date: .now),
        ]
        let secondNot = [
            NotRequestMenu(menu: "참타리 튀김", price: "10900"),
            NotRequestMenu(menu: "구운 콜리플라워", price: "10500")
        ]
        let secondRe = RequestMenu(menu: "김부각 with 로메스코 소스", price: "6900", howToRequest: "참치마요 대신 로메스코 소스 요청", isCheck: true)
        
        let secondData = VeganModel(
            placeModel: secondPlace, allVegan: false, someMenuVegan: true, ifRequestVegan: true, notRequestMenuArray: secondNot, requestMenuArray: [secondRe], comment: secondComment)
        
        let thridP = PlaceListModel(title: "코펜하겐", distance: "1", category: "음식점 > 카페", address: "부산 수영구 남천바다로21번길 47", phone: "070-4647-2420", url: "1", x: 129.114188712582, y: 35.1510240603296)
        let thridN = [
            NotRequestMenu(menu: "", price: "")
        ]
        let thridR = RequestMenu(menu: "라떼류 오트밀크 변경", price: "700", howToRequest: "우유대신 오트밀크로 변경", isCheck: true)
        
        let thridD = VeganModel(
            placeModel: thridP, allVegan: false, someMenuVegan: false, ifRequestVegan: true, notRequestMenuArray: thridN, requestMenuArray: [thridR])
        
        let vegan = [firstData, secondData, thridD]
        
        vegan.forEach {
            userDefaults?.setData($0)
        }
    }
}
