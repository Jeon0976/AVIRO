//
//  InrollPlacePresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit

protocol InrollPlaceProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func whenViewWillAppear()
    func whenViewDisappear()
    func reloadTableView(_ checkTable: Bool)
}

final class InrollPlacePresenter: NSObject {
    weak var viewController: InrollPlaceProtocol?
    
    private let userDefaultsManager: UserDefaultsManagerProtocol?
    
    // tableView Cell 개수 데이터 (최초 데이터)
    var notRequestMenu = [NotRequestMenu(menu: "", price: "")]
    var requestMenu = [RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false)]
    
    var storeNomalData: PlaceListModel!
    
    var veganModel: VeganModel?
    
    var allVegan = false
    var someMenuVegan = false
    var ifRequestVegan = false
    
    init(viewController: InrollPlaceProtocol,
         userDefaultsManager: UserDefaultsManagerProtocol = UserDefalutsManager()) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
    }
    
    func viewWillAppear() {
        viewController?.whenViewWillAppear()
    }
    
    func viewWillDisappear() {
        viewController?.whenViewDisappear()
    }
    
    // MARK: plus button 클릭 시 tableView Cell Data 추가
    func plusCell(_ checkCell: Bool) {
        if checkCell {
            let mockCellData = NotRequestMenu(menu: "", price: "")
            
            notRequestMenu.append(mockCellData)
            notRequestMenu.sort { ($0.hasData, $1.hasData) == (true, false) }
            
            viewController?.reloadTableView(true)
        } else {
            let mockCellData = RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false)
            
            requestMenu.append(mockCellData)
            requestMenu.sort { ($0.hasData, $1.hasData) == (true, false)}

            viewController?.reloadTableView(false)
        }
    }
    
    // MARK: Button Clieck Property 저장
    func buttonChecked(_ allVegan: Bool, _ someMenuVegan: Bool, _ ifRequestVegan: Bool) {
        self.allVegan = allVegan
        self.someMenuVegan = someMenuVegan
        self.ifRequestVegan = ifRequestVegan
    }
    
    // MARK: Place Model Update
    func updatePlaceModel(_ model: PlaceListModel) {
        storeNomalData = model
    }
    
    // MARK: Report 버튼 활성화 조건 -> 추후 수정 예정
    // store 다른 필수 조건도 삭제되면 버튼 비활성화 되어야 함
    func reportButtonPossible() -> Bool {
        if (requestMenu[0].menu != "" && requestMenu[0].price != "") ||
            (notRequestMenu[0].menu != "" && notRequestMenu[0].price != "") {
            return true
        } else { return false }
    }
    
    // MARK: report Button 클릭 시
    func reportData(_ title: String, _ address: String, _ category: String, _ phone: String ) {
        
        storeNomalData.title = title
        storeNomalData.address = address
        storeNomalData.category = category
        storeNomalData.phone = phone
        
        let veganModel = VeganModel(
            placeModel: storeNomalData,
            allVegan: allVegan,
            someMenuVegan: someMenuVegan,
            ifRequestVegan: ifRequestVegan,
            notRequestMenuArray: notRequestMenu,
            requestMenuArray: requestMenu
        )

        userDefaultsManager?.setData(veganModel)
        
        notRequestMenu = [NotRequestMenu(menu: "", price: "")]
        requestMenu = [RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false)]
        
        storeNomalData = nil
        allVegan = false
        someMenuVegan = false
        ifRequestVegan = false
        
        viewController?.reloadTableView(false)
        viewController?.reloadTableView(true)
    }
}
