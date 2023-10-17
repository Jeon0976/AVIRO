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

protocol AmplitudeProtocol {
    func setupUser(with userId: String)
    func withdrawalUser()
    func login()
    func logout()
    func popupPlace(with place: String)
    func editMenu(with place: String, beforeMenus: [AVIROMenu], afterMenus: [AVIROMenu])
    func searchPlace(with query: String)
    func uploadPlace(with place: String)
    func uploadReview(with place: String, review: String)
    func requestEditPlace(with place: String)
}

final class AmplitudeUtility: AmplitudeProtocol {
    private var amplitude: Amplitude? {
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
    func setupUser(with userId: String) {
        amplitude?.setUserId(userId: userId)
        amplitude?.track(eventType: AMType.signUp.rawValue)
    }
    
    // MARK: Withdrawal User
    func withdrawalUser() {
        amplitude?.track(eventType: AMType.withdrawal.rawValue)
    }
    
    // MARK: Login
    func login() {
        let identify = Identify()
        identify.set(property: "name", value: MyData.my.name)
        identify.set(property: "email", value: MyData.my.email)
        identify.set(property: "nickname", value: MyData.my.nickname)
        
        amplitude?.identify(identify: identify)
        amplitude?.track(eventType: AMType.login.rawValue)
    }
    
    // MARK: Logout
    func logout() {
        amplitude?.track(eventType: AMType.logout.rawValue)
    }
    
    // MARK: Popup Place
    func popupPlace(with place: String) {
        amplitude?.track(
            eventType: AMType.popupPlace.rawValue,
            eventProperties: ["Place": place]
        )
    }
    
    // MARK: Edit Menu
    func editMenu(with place: String, beforeMenus: [AVIROMenu], afterMenus: [AVIROMenu]) {
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
    func searchPlace(with query: String) {
        amplitude?.track(
            eventType: AMType.searchHSV.rawValue,
            eventProperties: ["Query": query]
        )
    }
    
    // MARK: Upload Place
    func uploadPlace(with place: String) {
        amplitude?.track(
            eventType: AMType.afterUploadPlace.rawValue,
            eventProperties: ["Place": place]
        )
    }
    
    // MARK: Upload Review
    func uploadReview(with place: String, review: String) {
        amplitude?.track(
            eventType: AMType.afterUploadReview.rawValue,
            eventProperties: [
                "Place": place,
                "Review": review
            ]
        )
    }
    
    // MARK: Request Edit Place
    func requestEditPlace(with place: String) {
        amplitude?.track(
            eventType: AMType.requestPlaceInfo.rawValue,
            eventProperties: ["Place": place]
        )
    }
}

final class AmplitudeUtilityDummy: AmplitudeProtocol {
    func setupUser(with userId: String) {
        return
    }
    
    func withdrawalUser() {
        return
    }
    
    func login() {
        return
    }
    
    func logout() {
        return
    }
    
    func popupPlace(with place: String) {
        return
    }
    
    func editMenu(with place: String, beforeMenus: [AVIROMenu], afterMenus: [AVIROMenu]) {
        return
    }
    
    func searchPlace(with query: String) {
        return
    }
    
    func uploadPlace(with place: String) {
        return
    }
    
    func uploadReview(with place: String, review: String) {
        return
    }
    
    func requestEditPlace(with place: String) {
        return
    }
    
}
