//
//  CustomAlertController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class CustomAlertController {
    static let shared = CustomAlertController()
    
    private init() { }
    
    func makeAlert(_ title: String, _ message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
//     TODO: user location 불러오기 오류
    func whenDeniedLocation(_ title: String, _ message: String) {
        
    }
    
    // MARK: user location 불러오기 거절 후 검색 했을 시 오류
    func whenSearchAfterDeniedLocation(_ title: String, _ message: String) -> UIAlertController {
        let alertController = makeAlert(title, message)
        let action = UIAlertAction(title: "확인", style: .destructive)
        alertController.addAction(action)
        
        return alertController
    }
    
//    // TODO: component 오류
//    func whenComponenetError() {
//
//    }
//
//    // TODO: api key plist 불러오기 오류
//    func whenAPIFetchError() {
//
//    }
    
    // TODO: urlsession 오류
    func whenUrlSessionError(_ title: String, _ message: String) {
        
    }
    
    // TODO: 마지막 페이지일때
    func whenLastLoadPage(_ title: String, _ message: String) {
        
    }
}
