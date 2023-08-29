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
    func dataBindingBottomView(menuArray: [MenuArray])
}

final class EditMenuPresenter {
    weak var viewController: EditMenuProtocol?
    
    private var placeId: String?
    private var isAll: Bool?
    private var isSome: Bool?
    private var isRequest: Bool?
    
    private var menuArray: [MenuArray]?
    
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
        
        print(placeId ,isAll, isSome, isRequest, menuArray)
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
        guard let menuArray = menuArray else { return }
        
        viewController?.dataBindingBottomView(menuArray: menuArray)
    }
}
