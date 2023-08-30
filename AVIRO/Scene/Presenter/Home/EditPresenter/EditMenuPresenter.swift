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
    private var isAll: Bool?
    private var isSome: Bool?
    private var isRequest: Bool? {
        didSet {
            guard let isRequest = isRequest,
                  let isSome = isSome
            else { return }
            if isRequest && !isSome {
                viewController?.dataBindingBottomView(false)
                isEnabledWhenRequestTable = false
            } else if isRequest && isSome {
                viewController?.dataBindingBottomView(false)
                isEnabledWhenRequestTable = true
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
}
