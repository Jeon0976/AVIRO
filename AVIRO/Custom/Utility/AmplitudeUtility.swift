//
//  AmplitudeUtility.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/10/10.
//

import Foundation

import AmplitudeSwift

// MARK: Amplitude
enum AMType: String {
    case signUp = "Sign Up"
    case withdrawal = "Withdrawal"
    
    case login = "Login"
    case logout = "Logout"
    
    case requestPlaceInfo = "Request to Edit Place Info"
    
    case searchHSV = "Search In HomeSearchView"
    
    case popupPlace = "Pop Up"
    
    case afterUploadPlace = "Upload Place"
    case afterUploadReview = "Upload Review"
    case afterEditMenu = "Edit Menu Table"
}

final class AmplitudeUtility {
    private static var amplitude: Amplitude? {
        if Thread.isMainThread {
            return (UIApplication.shared.delegate as? AppDelegate)?.amplitude
        } else {
            var amplitudeInstance: Amplitude?
            DispatchQueue.main.sync {
                amplitudeInstance = (UIApplication.shared.delegate as? AppDelegate)?.amplitude
            }
            return amplitudeInstance
        }
    }
    
    // MARK: Setup User
    static func setupUser(with userId: String) {
        amplitude?.setUserId(userId: userId)
        amplitude?.track(eventType: AMType.signUp.rawValue)
    }
    
    // MARK: Withdrawal User
    static func withdrawalUser() {
        amplitude?.track(eventType: AMType.withdrawal.rawValue)
    }
    
    // MARK: Login
    static func login() {
        let identify = Identify()
        identify.set(property: "name", value: MyData.my.name)
        identify.set(property: "email", value: MyData.my.email)
        identify.set(property: "nickname", value: MyData.my.nickname)
        
        amplitude?.identify(identify: identify)
        amplitude?.track(eventType: AMType.login.rawValue)
    }
    
    // MARK: Logout
    static func logout() {
        amplitude?.track(eventType: AMType.logout.rawValue)
    }
    
    // MARK: Popup Place
    static func popupPlace(with place: String) {
        amplitude?.track(
            eventType: AMType.popupPlace.rawValue,
            eventProperties: ["Place": place]
        )
    }
    
    // MARK: Edit Menu
    static func editMenu(with place: String, beforeMenus: [AVIROMenu], afterMenus: [AVIROMenu]) {
        var beforeMenusString = ""
        
        for (index, menu) in beforeMenus.enumerated() {
            let menuString = "\(index + 1): (\(menu.menu) \(menu.price) \(menu.howToRequest))"
            beforeMenusString += menuString + "\n"
        }
        
        var afterMenusString = ""
        
        for (index, menu) in afterMenus.enumerated() {
            let menuString = "\(index + 1): (\(menu.menu) \(menu.price) \(menu.howToRequest))"
            afterMenusString += menuString + "\n"
        }
        
        amplitude?.track(
            eventType: AMType.afterEditMenu.rawValue,
            eventProperties: [
                "Place": place,
                "BeforeChangedMenuArray": beforeMenusString,
                "AfterChangedMenuArray": afterMenusString
            ]
        )
    }
    
    // MARK: Search Place
    static func searchPlace(with query: String) {
        amplitude?.track(
            eventType: AMType.searchHSV.rawValue,
            eventProperties: ["Query": query]
        )
    }
    
    // MARK: Upload Place
    static func uploadPlace(with place: String) {
        amplitude?.track(
            eventType: AMType.afterUploadPlace.rawValue,
            eventProperties: ["Place": place]
        )
    }
    
    // MARK: Upload Review
    static func uploadReview(with place: String, review: String) {
        amplitude?.track(
            eventType: AMType.afterUploadReview.rawValue,
            eventProperties: [
                "Place": place,
                "Review": review
            ]
        )
    }
    
    // MARK: Request Edit Place
    static func requestEditPlace(with place: String) {
        amplitude?.track(
            eventType: AMType.requestPlaceInfo.rawValue,
            eventProperties: ["Place": place]
        )
    }
}
