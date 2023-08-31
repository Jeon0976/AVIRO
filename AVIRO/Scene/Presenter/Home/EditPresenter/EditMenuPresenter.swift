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
    func dataBindingTopView(isAll: Bool, isSome: Bool, isRequest: Bool)
    func dataBindingBottomView(_ isPresentingDefaultTable: Bool)
    func changeMenuTable(_ isPresentingDefaultTable: Bool)
}

final class EditMenuPresenter {
    enum Table {
        case Normal
        case Request
    }
    
    weak var viewController: EditMenuProtocol?
    
    private var placeId: String?
    
    private var isAll: Bool? {
        didSet {
            guard let isAll else { return }
            
            if isAll {
                viewController?.changeMenuTable(true)
            }
        }
    }
    
    private var isSome: Bool? {
        didSet {
            guard let isSome = isSome,
                  let isRequest = isRequest else { return }
            
            if isSome && !isRequest {
                viewController?.changeMenuTable(true)
            } else if !isSome && isRequest {
                viewController?.changeMenuTable(false)
                isEnabledWhenRequestTable = false
            } else if isSome && isRequest {
                viewController?.changeMenuTable(false)
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
                viewController?.changeMenuTable(false)
                isEnabledWhenRequestTable = false
            } else if isRequest && isSome {
                viewController?.changeMenuTable(false)
                isEnabledWhenRequestTable = true
            } else if !isRequest {
                viewController?.changeMenuTable(true)
            }
        }
    }
    
    var isEnabledWhenRequestTable = true
    
    private var menuArray: [MenuArray]?
    
    var menuArrayCount: Int {
        guard let menuArray = menuArray else { return 0 }
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
        self.isSome = isSome
        self.isRequest = isRequest
        self.menuArray = menuArray
        
        print(placeId, isAll, isSome, isRequest, menuArray)
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
        
        dataBinding()
    }
    
    func dataBinding() {
        dataBindingTopView()
        dataBindingBottomView()
    }
    
    private func dataBindingTopView() {
        guard let isAll = isAll,
              let isSome = isSome,
              let isRequest = isRequest else { return }
        
        viewController?.dataBindingTopView(isAll: isAll, isSome: isSome, isRequest: isRequest)
    }
    
    private func dataBindingBottomView() {
        guard let menuArray = menuArray,
              let isRequest = isRequest,
              let isSome = isSome
        else { return }
        
        if isRequest && !isSome {
            viewController?.dataBindingBottomView(false)
            isEnabledWhenRequestTable = false
        } else if isRequest && isSome {
            viewController?.dataBindingBottomView(false)
            isEnabledWhenRequestTable = true
        } else {
            viewController?.dataBindingBottomView(true)
        }
    }
    
    func checkMenuData(_ indexPath: IndexPath) -> MenuArray? {
        guard let menuArray = menuArray else { return nil }
        
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
        print(selected)

        if selected {
            isRequest = true
        } else {
            isRequest = false
        }
    }
    
//    private func fixedRequestTable() {
//        for index in requestTableModel.indices {
//            requestTableModel[index].isCheck = true
//            requestTableModel[index].isEnabled = false
//        }
//        viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
//    }
//
//    private func unFixedRequestTable() {
//        for index in requestTableModel.indices {
//            requestTableModel[index].isEnabled = true
//        }
//        viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
//    }
}
