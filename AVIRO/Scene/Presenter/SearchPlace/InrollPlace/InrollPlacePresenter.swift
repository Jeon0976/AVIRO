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
    
    private let aviroManager = AVIROAPIManager()
    
    private var storeNomalData: PlaceListModel!
    private var menuArray = [MenuArray]()
    
    private var veganTableFieldModel = [VeganTableFieldModel(menu: "", price: "")]
    private var requestTableFieldModel = [RequestTableFieldModel(menu: "", price: "", howToRequest: "", isCheck: false)]
    
    // MARK: Table Count 처리
    var veganTableCount: Int  {
        veganTableFieldModel.count
    }
    var requestTableCount: Int {
        requestTableFieldModel.count
    }
    
    var allVegan = false
    var someMenuVegan = false
    var ifRequestVegan = false
    
    init(viewController: InrollPlaceProtocol) {
        self.viewController = viewController
    }
        
    // MARK: ViewDidLoad
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
    }
    
    // MARK: ViewWillAppear
    func viewWillAppear() {
        viewController?.whenViewWillAppear()
    }
    
    // MARK: ViewDisAppear
    func viewWillDisappear() {
        viewController?.whenViewDisappear()
    }
    
    // MARK: plus button 클릭 시 tableView Cell Data 추가
    func plusCell(_ checkCell: Bool) {
        if checkCell {
            let mockCellData = VeganTableFieldModel(menu: "", price: "")
            
            veganTableFieldModel.append(mockCellData)
            veganTableFieldModel.sort { ($0.hasData, $1.hasData) == (true, false) }
            
            viewController?.reloadTableView(true)
        } else {
            let mockCellData = RequestTableFieldModel(menu: "", price: "", howToRequest: "", isCheck: false)
            
            requestTableFieldModel.append(mockCellData)
            requestTableFieldModel.sort { ($0.isCheck && !$1.isCheck) || (($0.isCheck == $1.isCheck) && $0.hasData && !$1.hasData) }

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
        if (veganTableFieldModel[0].menu != "" && veganTableFieldModel[0].price != "") ||
            (requestTableFieldModel[0].menu != "" && requestTableFieldModel[0].price != "") {
            return true
        } else { return false }
    }
    
    // MARK: Array 합치기
    // TODO: Price 처음부터 숫자로만 입력하도록 유도해야 함
    func mergeArray() -> [MenuArray] {
        let veganMenu = veganTableFieldModel
            .filter{ $0.hasData }
            .map {
                MenuArray(
                    menuType: MenuType.vegan.value,
                    menu: $0.menu,
                    price: Int($0.price) ?? 0,
                    howToRequest: "", isCheck: false
                )
            }
        
        let requestMenu = requestTableFieldModel
            .filter { $0.hasData }
            .map {
                MenuArray(
                    menuType: MenuType.needToRequset.value,
                    menu: $0.menu, price: Int($0.price) ?? 0,
                    howToRequest: $0.howToRequest,
                    isCheck: $0.isCheck
                )
            }
        
        let test = veganMenu + requestMenu
        print(test)
        return veganMenu + requestMenu
    }
    
    // MARK: report Button 클릭 시
    func reportData(_ title: String, _ address: String, _ category: String, _ phone: String, completionHandler: ((VeganModel) -> Void) ) {
        
        storeNomalData.title = title
        storeNomalData.address = address
        storeNomalData.category = category
        storeNomalData.phone = phone
        
        self.menuArray = mergeArray()
        
        let veganModel = VeganModel(
            title: title,
            category: category,
            address: address,
            phone: phone,
            url: storeNomalData.url,
            x: storeNomalData.x,
            y: storeNomalData.y,
            allVegan: allVegan,
            someMenuVegan: someMenuVegan,
            ifRequestVegan: ifRequestVegan,
            menuArray: menuArray
        )
        
        resetArray(request: false)
        resetArray(request: true)
        
        storeNomalData = nil
        allVegan = false
        someMenuVegan = false
        ifRequestVegan = false
        
        viewController?.reloadTableView(false)
        viewController?.reloadTableView(true)
        
        completionHandler(veganModel)
    }
    
    // MARK: API 호출하기
    func postData(_ veganModel: VeganModel) {
        
        aviroManager.postPlaceModel(veganModel)
    }
}

// MARK: TableView 관련 함수


extension InrollPlacePresenter {
    // MARK: Table IndexPath.row 값 불러오기
    func checkVeganTable(_ indexPath: IndexPath) -> VeganTableFieldModel {
        return veganTableFieldModel[indexPath.row]
    }
    
    func checkRequestTable(_ indexPath: IndexPath) -> RequestTableFieldModel {
        return requestTableFieldModel[indexPath.row]
    }
    
    // MARK: Table IndexPath.row 값 저장하기
    func plusVeganTable(_ indexPath: IndexPath,
                        _ menu: String?,
                        _ price: String?
    ) {
        if let menu = menu {
            veganTableFieldModel[indexPath.row].menu = menu
        }
        if let price = price {
            veganTableFieldModel[indexPath.row].price = price
        }
    }
    
    func plusRequestTable(_ indexPath: IndexPath,
                          _ menu: String?,
                          _ price: String?,
                          _ howToRequest: String?
    ) {
        if let menu = menu {
            requestTableFieldModel[indexPath.row].menu = menu
        }
        
        if let price = price {
            requestTableFieldModel[indexPath.row].price = price
        }
        
        if let howToRequest = howToRequest {
            requestTableFieldModel[indexPath.row].howToRequest = howToRequest
            requestTableFieldModel[indexPath.row].isCheck = true
        }
    }
    // MARK: Table View 값 초기화
    func resetArray(request: Bool) {
        if request {
            requestTableFieldModel = [
                RequestTableFieldModel(
                    menu: "",
                    price: "",
                    howToRequest: "",
                    isCheck: false
                )
            ]
        } else {
            veganTableFieldModel = [
                VeganTableFieldModel(
                    menu: "",
                    price: ""
                )
            ]
        }
    }
}
