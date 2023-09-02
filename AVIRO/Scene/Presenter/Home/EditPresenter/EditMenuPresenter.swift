//
//  MenuEditPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import Foundation

protocol EditMenuProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func updateEditMenuButton(_ isEnabled: Bool)
    func handleClosure()
    func dataBindingTopView(isAll: Bool, isSome: Bool, isRequest: Bool)
    func dataBindingBottomView(_ isPresentingDefaultTable: Bool)
    func updateMenuTableView(_ isPresentingDefaultTable: Bool)
    func menuTableReload(_ isPresentingDefaultTable: Bool)
}

final class EditMenuPresenter {
    weak var viewController: EditMenuProtocol?
    
    private var placeId: String?
    
    private var isAll: Bool? {
        didSet {
            guard let isAll else { return }
            
            if isAll {
                isDefaultMenuTable = true
            }
        }
    }
    
    private var isSome: Bool? {
        didSet {
            guard let isSome = isSome,
                  let isRequest = isRequest else { return }
            
            if isSome && !isRequest {
                viewController?.updateMenuTableView(true)
            } else if !isSome && isRequest {
                isDefaultMenuTable = false
                isEnabledWhenRequestTable = false
            } else if isSome && isRequest {
                isDefaultMenuTable = false
                isEnabledWhenRequestTable = true
            }
        }
    }
    
    private var isRequest: Bool? {
        didSet {
            guard let isRequest = isRequest,
                  let isSome = isSome
            else { return }
            if isRequest && !isSome {
                isDefaultMenuTable = false
                isEnabledWhenRequestTable = false
            } else if isRequest && isSome {
                isDefaultMenuTable = false
                isEnabledWhenRequestTable = true
            } else if !isRequest {
                isDefaultMenuTable = true
            }
        }
    }
    
    private var isDefaultMenuTable: Bool? {
        didSet {
            guard let isDefaultMenuTable = isDefaultMenuTable else { return }
            if isDefaultMenuTable {
                viewController?.updateMenuTableView(true)
            } else {
                viewController?.updateMenuTableView(false)
            }
        }
    }
    
    private var isEnabledWhenRequestTable: Bool? {
        didSet {
            guard let isEnabledWhenRequestTable = isEnabledWhenRequestTable else { return }
            
            if isEnabledWhenRequestTable {
                unFixedRequestTable()
            } else {
                fixedRequestTable()
            }
        }
    }
    
    private var menuArray: [MenuArray]?
    private var initAll: Bool!
    private var initSome: Bool!
    private var initRequest: Bool!
    
    private var veganMenuArray: [VeganTableFieldModelForEdit]?
    
    private var requestVeganMenuArray: [RequestTableFieldModelForEdit]?
    
    var menuArrayCount: Int {
        guard let menuArray = menuArray else { return 0 }
        return menuArray.count
    }
    
    var veganMenuCount: Int {
        guard let menuArray = veganMenuArray else { return 0 }
        return menuArray.count
    }

    var requestVeganMenuCount: Int {
        guard let menuArray = requestVeganMenuArray else { return 0 }
        return menuArray.count
    }
    
    init(viewController: EditMenuProtocol,
         placeId: String? = nil,
         isAll: Bool? = nil,
         isSome: Bool? = nil,
         isRequest: Bool? = nil,
         menuArray: [MenuArray]? = nil
    ) {
        self.viewController = viewController
        self.placeId = placeId
        self.isAll = isAll
        self.initAll = isAll
        self.isSome = isSome
        self.initSome = isSome
        self.isRequest = isRequest
        self.initRequest = isRequest
        self.menuArray = menuArray
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
        viewController?.handleClosure()

        dataBinding()
    }
    
    func dataBinding() {
        updateTableData()
        dataBindingTopView()
        dataBindingBottomView()
    }
    
    private func updateTableData() {
        veganMenuArray = []
        requestVeganMenuArray = []
        
        guard let menuArray = menuArray else { return }
        
        menuArray.forEach {
            let id = $0.menuId
            let menu = $0.menu
            let price = $0.price
            let howToRequest = $0.howToRequest
            let isCheck = $0.isCheck
            
            let veganMenuTable = VeganTableFieldModelForEdit(id: id, menu: menu, price: price)
            
            let requestMenuTable = RequestTableFieldModelForEdit(id: id, menu: menu, price: price, howToRequest: howToRequest, isCheck: isCheck, isEnabled: true)
            veganMenuArray?.append(veganMenuTable)
            requestVeganMenuArray?.append(requestMenuTable)
        }
    }
    
    private func dataBindingTopView() {
        guard let isAll = isAll,
              let isSome = isSome,
              let isRequest = isRequest else { return }
        
        viewController?.dataBindingTopView(isAll: isAll, isSome: isSome, isRequest: isRequest)
    }
    
    private func dataBindingBottomView() {
        guard (menuArray != nil),
              let isRequest = isRequest,
              let isSome = isSome
        else { return }
        
        if isRequest && !isSome {
            let isDefaultMenuTable = false
            
            self.isDefaultMenuTable = isDefaultMenuTable
            isEnabledWhenRequestTable = false
            
            viewController?.dataBindingBottomView(isDefaultMenuTable)
        } else if isRequest && isSome {
            let isDefaultMenuTable = false
            
            self.isDefaultMenuTable = isDefaultMenuTable
            isEnabledWhenRequestTable = true
            
            viewController?.dataBindingBottomView(isDefaultMenuTable)
        } else {
            let isDefaultMenuTable = true
            
            self.isDefaultMenuTable = isDefaultMenuTable

            viewController?.dataBindingBottomView(isDefaultMenuTable)
        }
    }
    
    func checkMenuData(_ indexPath: IndexPath) -> MenuArray? {
        
        guard let menuArray = menuArray else { return nil }
        
        return menuArray[indexPath.row]
    }
    
    func checkVeganMenuData(_ indexPath: IndexPath) -> VeganTableFieldModelForEdit? {
        
        guard let menuArray = veganMenuArray else { return nil }

        return menuArray[indexPath.row]
    }
    
    func checkRequestVeanMenuData(_ indexPath: IndexPath) -> RequestTableFieldModelForEdit? {
        
        guard let menuArray = requestVeganMenuArray else { return nil }

        return menuArray[indexPath.row]
    }
    
    func changedVeganOption(_ text: String, _ selected: Bool) {
        switch text {
        case "모든 메뉴가\n비건":
            tappedAllVegan(selected)
        case "일부 메뉴만\n비건":
            tappedSomeVegan(selected)
        case "비건 메뉴로\n요청 가능":
            tappedRequestVegan(selected)
        default:
            break
        }
    }
    
    private func tappedAllVegan(_ selected: Bool) {
        isSome = false
        isRequest = false

        if selected {
            isAll = true
        } else {
            isAll = false
        }
    }
    
    private func tappedSomeVegan(_ selected: Bool) {
        isAll = false
        
        if selected {
            isSome = true
        } else {
            isSome = false
        }
    }
    
    private func tappedRequestVegan(_ selected: Bool) {
        isAll = false

        if selected {
            isRequest = true
        } else {
            isRequest = false
        }
    }
    
    private func fixedRequestTable() {
        guard let menuArray = requestVeganMenuArray,
              let isDefaultMenuTable = isDefaultMenuTable
        else { return }
        
        for index in menuArray.indices {
            requestVeganMenuArray?[index].isCheck = true
            requestVeganMenuArray?[index].isEnabled = false
        }
        viewController?.menuTableReload(isDefaultMenuTable)
    }
    
    private func unFixedRequestTable() {
        guard let menuArray = requestVeganMenuArray,
              let isDefaultMenuTable = isDefaultMenuTable
        else { return }
        
        for index in menuArray.indices {
            requestVeganMenuArray?[index].isEnabled = true
        }
        
        viewController?.menuTableReload(isDefaultMenuTable)
    }
    
    func editingMenuField(_ menu: String, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if isDefaultMenuTable {
            veganMenuArray?[indexPath.row].menu = menu
        } else {
            requestVeganMenuArray?[indexPath.row].menu = menu
        }
    }
    
    func editingPriceField(_ price: String, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if isDefaultMenuTable {
            veganMenuArray?[indexPath.row].price = price
        } else {
            requestVeganMenuArray?[indexPath.row].price = price
        }
    }
    
    func editingRequestButton(_ isSelected: Bool, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if !isDefaultMenuTable {
            requestVeganMenuArray?[indexPath.row].isCheck = isSelected
        }
    }
    
    func editingRequestField(_ request: String, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if !isDefaultMenuTable {
            requestVeganMenuArray?[indexPath.row].howToRequest = request
        }
    }
    
    func deleteMenu(_ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if isDefaultMenuTable {
            veganMenuArray?.remove(at: indexPath.row)
        } else {
            requestVeganMenuArray?.remove(at: indexPath.row)
        }
        viewController?.menuTableReload(isDefaultMenuTable)
        viewController?.updateMenuTableView(isDefaultMenuTable)
    }
    
    func plusMenu() {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if isDefaultMenuTable {
            let field = VeganTableFieldModel(menu: "",
                                             price: ""
            )
                        
            let editModel = VeganTableFieldModelForEdit(
                id: field.id.uuidString,
                menu: field.menu,
                price: field.price
            )
            
            veganMenuArray?.append(editModel)
        } else {
            guard let isEnabledWhenRequestTable = isEnabledWhenRequestTable else { return }
            
            if isEnabledWhenRequestTable {
                let field = RequestTableFieldModel(
                    menu: "",
                    price: "",
                    howToRequest: "",
                    isCheck: false,
                    isEnabled: true
                )
                
                let editModel = RequestTableFieldModelForEdit(
                    id: field.id.uuidString,
                    menu: field.menu,
                    price: field.price,
                    howToRequest: field.howToRequest,
                    isCheck: field.isCheck,
                    isEnabled: field.isEnabled
                )
                
                requestVeganMenuArray?.append(editModel)
            } else {
                let field = RequestTableFieldModel(
                    menu: "",
                    price: "",
                    howToRequest: "",
                    isCheck: true,
                    isEnabled: false
                )
                
                let editModel = RequestTableFieldModelForEdit(
                    id: field.id.uuidString,
                    menu: field.menu,
                    price: field.price,
                    howToRequest: field.howToRequest,
                    isCheck: field.isCheck,
                    isEnabled: field.isEnabled
                )
                
                requestVeganMenuArray?.append(editModel)
            }
        }
        
        viewController?.menuTableReload(isDefaultMenuTable)
        viewController?.updateMenuTableView(isDefaultMenuTable)
    }
}
