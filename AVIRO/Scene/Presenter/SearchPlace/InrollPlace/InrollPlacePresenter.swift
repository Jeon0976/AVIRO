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
    func reloadTableView(_ checkTable: Bool)
}

final class InrollPlacePresenter: NSObject {
    weak var viewController: InrollPlaceProtocol?
    
    private let userDefaultsManager: UserDefaultsManagerProtocol?
    
    // tableView Cell 개수 데이터 (최초 데이터)
    var notRequestMenu = [NotRequestMenu](repeating: NotRequestMenu(menu: "", price: ""), count: 1)
    var requestMenu = [RequestMenu](repeating: RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false), count: 1)
    
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
    
    func buttonChecked(_ allVegan: Bool, _ someMenuVegan: Bool, _ ifRequestVegan: Bool) {
        self.allVegan = allVegan
        self.someMenuVegan = someMenuVegan
        self.ifRequestVegan = ifRequestVegan
    }
    
    func updatePlaceModel(_ model: PlaceListModel) {
        storeNomalData = model
    }
    
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
        
        notRequestMenu = [NotRequestMenu](repeating: NotRequestMenu(menu: "", price: ""), count: 1)
        requestMenu = [RequestMenu](repeating: RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false), count: 1)
        
        storeNomalData = nil
        allVegan = false
        someMenuVegan = false
        ifRequestVegan = false
        
        viewController?.reloadTableView(false)
        viewController?.reloadTableView(true)
    }
}
