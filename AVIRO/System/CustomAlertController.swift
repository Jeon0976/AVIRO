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
    
    // TODO: user location 불러오기 오류
    func whenDeniedLocation() {
        
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
    func whenUrlSessionError() {
        
    }
    
    // TODO: 마지막 페이지일때
    func whenLastLoadPage() {
        
    }
}
