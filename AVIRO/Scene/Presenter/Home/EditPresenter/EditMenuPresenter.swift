//
//  MenuEditPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

protocol EditMenuProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func updateEditMenuButton(_ isEnabled: Bool)
    func handleClosure()
    func dataBindingTopView(isAll: Bool, isSome: Bool, isRequest: Bool)
    func dataBindingBottomView(_ isPresentingDefaultTable: Bool)
    func updateMenuTableView(_ isPresentingDefaultTable: Bool)
    func menuTableReload(_ isPresentingDefaultTable: Bool)
    func popViewController()
}

final class EditMenuPresenter {
    weak var viewController: EditMenuProtocol?
    
    private var placeId: String?
    
    private var isAll: Bool? {
        didSet {
            guard let isAll else { return }
            
            if isAll {
                isDefaultMenuTable = true
                allUpdateMenuArrayId()
            }
        }
    }
    
    private var isSome: Bool? {
        didSet {
            guard let isSome = isSome,
                  let isRequest = isRequest else { return }
            
            if isSome && !isRequest {
                viewController?.updateMenuTableView(true)
                allUpdateMenuArrayId()

            } else if !isSome && isRequest {
                isDefaultMenuTable = false
                isEnabledWhenRequestTable = false
                allUpdateMenuArrayId()

            } else if isSome && isRequest {
                isDefaultMenuTable = false
                isEnabledWhenRequestTable = true
                allUpdateMenuArrayId()

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
                allUpdateMenuArrayId()

            } else if isRequest && isSome {
                isDefaultMenuTable = false
                isEnabledWhenRequestTable = true
                allUpdateMenuArrayId()

            } else if !isRequest {
                isDefaultMenuTable = true
                allUpdateMenuArrayId()

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
    
    private func allUpdateMenuArrayId() {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        if isDefaultMenuTable {
            guard let initVeganMenuArray = initVeganMenuArray else { return }
            initVeganMenuArray.forEach { initVegan in
                if !updateMenuArrayId.contains(where: { initVegan.id == $0.1 && isDefaultMenuTable == $0.0 }) {
                    updateMenuArrayId.append((isDefaultMenuTable, initVegan.id))
                }
            }
        } else {
            guard let initRequestVeganMenuArray = initRequestVeganMenuArray else { return }
            initRequestVeganMenuArray.forEach { initVegan in
                if !updateMenuArrayId.contains(where: { initVegan.id == $0.1 && isDefaultMenuTable == $0.0 }) {
                    updateMenuArrayId.append((isDefaultMenuTable, initVegan.id))
                }
            }
        }
    }
    
    private var menuArray: [AVIROMenu]?
    private var initAll: Bool!
    private var initSome: Bool!
    private var initRequest: Bool!
    
    private var initVeganMenuArray: [VeganTableFieldModelForEdit]?
    private var initRequestVeganMenuArray: [RequestTableFieldModelForEdit]?
    
    private var veganMenuArray: [VeganTableFieldModelForEdit]?
    private var requestVeganMenuArray: [RequestTableFieldModelForEdit]?
    
    private var deletedMenuArrayId: [(Bool, String)] = []
    private var insertMenuArrayId: [(Bool, String)] = []
    private var updateMenuArrayId: [(Bool, String)] = []
    
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
    
    var afterEditMenuChangedMenus: (() -> Void)?
    var afterEditMenuChangedVeganMarker: ( (EditMenuChangedMarkerModel) -> Void)?
    
    init(viewController: EditMenuProtocol,
         placeId: String? = nil,
         isAll: Bool? = nil,
         isSome: Bool? = nil,
         isRequest: Bool? = nil,
         menuArray: [AVIROMenu]? = nil
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
    
    func viewWillAppear() {
        addKeyboardNotification()
    }
    
    func viewWillDisappear() {
        removeKeyboardNotification()
    }
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            viewController?.keyboardWillShow(height: keyboardRectangle.height)
        }
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        viewController?.keyboardWillHide()
        
    }
    
    func dataBinding() {
        updateTableData()
        dataBindingTopView()
        dataBindingBottomView()
    }
    
    private func updateTableData() {
        veganMenuArray = []
        requestVeganMenuArray = []
        initVeganMenuArray = []
        initRequestVeganMenuArray = []
        
        guard let menuArray = menuArray else { return }
        
        menuArray.forEach {
            let id = $0.menuId
            let menu = $0.menu
            let price = $0.price
            let howToRequest = $0.howToRequest
            let isCheck = $0.isCheck
            
            let veganMenuTable = VeganTableFieldModelForEdit(
                id: id,
                menu: menu,
                price: price
            )
            
            let requestMenuTable = RequestTableFieldModelForEdit(
                id: id,
                menu: menu,
                price: price,
                howToRequest: howToRequest,
                isCheck: isCheck,
                isEnabled: true
            )
            
            veganMenuArray?.append(veganMenuTable)
            initVeganMenuArray?.append(veganMenuTable)
            requestVeganMenuArray?.append(requestMenuTable)
            initRequestVeganMenuArray?.append(requestMenuTable)
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
    
    func checkMenuData(_ indexPath: IndexPath) -> AVIROMenu? {
        
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
        
        // MARK: 여기 추가
        enabledEditButton()
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
        enabledEditButton()
    }
    
    private func unFixedRequestTable() {
        guard let menuArray = requestVeganMenuArray,
              let isDefaultMenuTable = isDefaultMenuTable
        else { return }
        
        for index in menuArray.indices {
            requestVeganMenuArray?[index].isEnabled = true
        }
        
        viewController?.menuTableReload(isDefaultMenuTable)
        enabledEditButton()
    }
    
    func editingMenuField(_ menu: String, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if isDefaultMenuTable {
            veganMenuArray?[indexPath.row].menu = menu
        } else {
            requestVeganMenuArray?[indexPath.row].menu = menu
        }
        
        updateArrayState(indexPath.row)
        enabledEditButton()
    }
    
    func editingPriceField(_ price: String, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if isDefaultMenuTable {
            veganMenuArray?[indexPath.row].price = price
        } else {
            requestVeganMenuArray?[indexPath.row].price = price
        }
        
        updateArrayState(indexPath.row)
        enabledEditButton()
    }
    
    func editingRequestButton(_ isSelected: Bool, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if !isDefaultMenuTable {
            requestVeganMenuArray?[indexPath.row].isCheck = isSelected
            
            if !isSelected {
                requestVeganMenuArray?[indexPath.row].howToRequest = ""
                viewController?.menuTableReload(isDefaultMenuTable)
            }
        }
        
        updateArrayState(indexPath.row)
        enabledEditButton()
    }
    
    func editingRequestField(_ request: String, _ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if !isDefaultMenuTable {
            requestVeganMenuArray?[indexPath.row].howToRequest = request
        }
        
        updateArrayState(indexPath.row)
        enabledEditButton()
    }
    
    func deleteMenu(_ indexPath: IndexPath) {
        guard let isDefaultMenuTable = isDefaultMenuTable,
              let isSome = isSome,
              let isRequest = isRequest
        else { return }
        
        if isDefaultMenuTable && veganMenuCount > 1 {
            guard let id = veganMenuArray?[indexPath.row].id else { return }
            
            deletedMenuArrayId.append((isDefaultMenuTable, id))
            
            veganMenuArray?.remove(at: indexPath.row)
        } else if !isDefaultMenuTable && isSome && isRequest && requestVeganMenuCount > 2 {
            guard let id = requestVeganMenuArray?[indexPath.row].id else { return }
            
            deletedMenuArrayId.append((isDefaultMenuTable, id))
            
            requestVeganMenuArray?.remove(at: indexPath.row)
        } else if !isDefaultMenuTable && !isSome && isRequest && requestVeganMenuCount > 1 {
            guard let id = requestVeganMenuArray?[indexPath.row].id else { return }
            
            deletedMenuArrayId.append((isDefaultMenuTable, id))
            
            requestVeganMenuArray?.remove(at: indexPath.row)
        }
        viewController?.menuTableReload(isDefaultMenuTable)
        viewController?.updateMenuTableView(isDefaultMenuTable)
        enabledEditButton()
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
        enabledEditButton()
    }
    
    private func updateArrayState(_ index: Int) {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return }
        
        if isDefaultMenuTable {
            guard let menuArray = menuArray,
                let veganMenuArray = veganMenuArray
            else { return }
            
            let id = veganMenuArray[index].id
            
            if menuArray.contains(where: { $0.menuId == id}) {
                if !updateMenuArrayId.contains(where: { $0.1 == id && $0.0 == isDefaultMenuTable }) {
                    updateMenuArrayId.append((isDefaultMenuTable, id))
                }
            } else {
                if !insertMenuArrayId.contains(where: { $0.1 == id && $0.0 == isDefaultMenuTable }) {
                    insertMenuArrayId.append((isDefaultMenuTable, id))
                }
            }
        } else {
            guard let menuArray = menuArray,
                let requestVeganMenuArray = requestVeganMenuArray
            else { return }
            
            let id = requestVeganMenuArray[index].id
            
            if menuArray.contains(where: { $0.menuId == id}) {
                if !updateMenuArrayId.contains(where: { $0.1 == id && $0.0 == isDefaultMenuTable }) {
                    updateMenuArrayId.append((isDefaultMenuTable, id))
                }
            } else {
                if !insertMenuArrayId.contains(where: { $0.1 == id && $0.0 == isDefaultMenuTable }) {
                    insertMenuArrayId.append((isDefaultMenuTable, id))
                }
            }
        }
        
    }
    
    private func enabledEditButton() {
        /// 버튼이 전부 비활성화 될 때
        guard !(isAll == false && isSome == false && isRequest == false) else {
            viewController?.updateEditMenuButton(false)
            return
        }
        
        /// 기존 데이터와 비교해서 같을 시 false
        guard updateEditButtonFromVeganOption() || updateEditButtonFromVeganMenus() else {
            
            viewController?.updateEditMenuButton(false)
            return }
        
        if isSome == true && isRequest == true {
            if !checkRequestArrayWhenSomeRequest() {
                viewController?.updateEditMenuButton(false)
                return
            }
        }
        
        /// empty 데이터가 있는지 확인 함수, 없으면 -> true
        let hasEmptyData = afterCompareInitData()

        viewController?.updateEditMenuButton(hasEmptyData)
    }
    
    private func checkRequestArrayWhenSomeRequest() -> Bool {
        let count = requestVeganMenuCount >= 2
        
        guard let checkVegan = requestVeganMenuArray?.contains(where: { $0.howToRequest == "" && !$0.isCheck }) else { return false }
        guard let checkRequest = requestVeganMenuArray?.contains(where: { $0.howToRequest != "" && $0.isCheck }) else { return false }
        
        return count && checkVegan && checkRequest
    }
    
    /// 최초 버튼이랑 전부 같을 때
    private func updateEditButtonFromVeganOption() -> Bool {
        if initAll == isAll,
           initSome == isSome,
           initRequest == isRequest {
            return false
        } else {
            return true
        }
    }
    
    /// 최초 메뉴 데이터와 같을 때 비활성화
    private func updateEditButtonFromVeganMenus() -> Bool {
        !compareMenuData()
    }
        
    private func compareMenuData() -> Bool {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return false }
        
        if isDefaultMenuTable {
            return whenDefaultMenuTableCompareMenuData()
        } else {
            return whenNotDefaultMenuTableCompareMenuData()
        }
    }
    
    private func whenDefaultMenuTableCompareMenuData() -> Bool {
        return initVeganMenuArray == veganMenuArray
    }
    
    private func whenNotDefaultMenuTableCompareMenuData() -> Bool {
        return initRequestVeganMenuArray == requestVeganMenuArray
    }
    
    private func afterCompareInitData() -> Bool {
        guard let isDefaultMenuTable = isDefaultMenuTable else { return false }
        
        if isDefaultMenuTable {
            return !whenDefaultMenuTableHasEmptyData()
        } else {
            return !whenNotDefaultMenuTableHasEmptyData()
        }
    }
    
    private func whenDefaultMenuTableHasEmptyData() -> Bool {
        guard let veganMenuArray = veganMenuArray else { return true }
       return veganMenuArray.contains(where: { $0.menu == "" || $0.price == "" }) || veganMenuArray.isEmpty
    }
    
    private func whenNotDefaultMenuTableHasEmptyData() -> Bool {
        guard let requestVeganMenuArray = requestVeganMenuArray else { return true }

        let hasEmptyData = requestVeganMenuArray.contains(where: { $0.menu == "" || $0.price == "" }) || requestVeganMenuArray.isEmpty
        
        let hasEmptyRequest = requestVeganMenuArray.contains(where: {
            $0.isCheck && $0.howToRequest == ""
        })
        
        return hasEmptyData || hasEmptyRequest
    }
    
    // MARK: api 호출할 데이터 필터링하기
    func filteringDataSet() {
        guard let isDefaultMenuTable = isDefaultMenuTable,
        let placeId = placeId,
        let isAll = isAll,
        let isSome = isSome,
        let isRequest = isRequest
        else { return }
        
        let deletedArray = filteringDeletedMenuData(isDefaultMenuTable)
        let updatedArray = filteringUpdatedMenuData(isDefaultMenuTable)
        let insertedArray = filteringInsertMenuData(isDefaultMenuTable)
        
        let editMenu = AVIROEditMenuModel(
            placeId: placeId,
            userId: MyData.my.id,
            allVegan: isAll,
            someMenuVegan: isSome,
            ifRequestVegan: isRequest,
            deleteArray: deletedArray,
            updateArray: updatedArray,
            insertArray: insertedArray
        )

        updateMenuData(editMenu)
    }
    
    private func filteringDeletedMenuData(_ isDefaultMenuTable: Bool) -> [String] {
        var deletedArray = [String]()
        
        deletedMenuArrayId.forEach {
            if $0.0 == isDefaultMenuTable {
                deletedArray.append($0.1)
            }
        }
        
        return deletedArray
    }
    
    private func filteringUpdatedMenuData(_ isDefaultMenuTable: Bool) -> [AVIROMenu] {
        var updatedMenuArray = [AVIROMenu]()
        
        if isDefaultMenuTable {
            updateMenuArrayId.forEach { updatedMenu in
                if updatedMenu.0 == isDefaultMenuTable {
                    veganMenuArray?.forEach { veganMenu in
                        if updatedMenu.1 == veganMenu.id {
                            guard let menu = checkUpdatedMenuDataWhenVeganMenu(veganMenu) else { return }
                            
                            updatedMenuArray.append(menu)
                        }
                    }
                }
            }
        } else {
            updateMenuArrayId.forEach { updatedMenu in
                if updatedMenu.0 == isDefaultMenuTable {
                    requestVeganMenuArray?.forEach { veganMenu in
                        if updatedMenu.1 == veganMenu.id {
                            guard let menu = checkUpdatedMenuDataWhenRequestMenu(veganMenu) else { return }
                            
                            updatedMenuArray.append(menu)
                        }
                    }
                }
            }
        }
        
        return updatedMenuArray
    }
    
    private func checkUpdatedMenuDataWhenVeganMenu(_ menu: VeganTableFieldModelForEdit) -> AVIROMenu? {
        guard let initVeganMenuArray = initVeganMenuArray else { return nil }
        
        var menuData: AVIROMenu?
        
        initVeganMenuArray.forEach { initMenu in
            if initMenu.id == menu.id  {
                menuData = AVIROMenu(
                    menuId: menu.id,
                    menuType: MenuType.vegan.rawValue,
                    menu: menu.menu,
                    price: menu.price,
                    howToRequest: "",
                    isCheck: false
                )
            }
        }
        
        return menuData
    }
    
    private func checkUpdatedMenuDataWhenRequestMenu(_ menu: RequestTableFieldModelForEdit) -> AVIROMenu? {
        guard let initRequestVeganMenuArray = initRequestVeganMenuArray else { return nil }
        
        var menuData: AVIROMenu?
        
        initRequestVeganMenuArray.forEach { initMenu in
            if initMenu.id == menu.id {
                menuData = AVIROMenu(
                    menuId: menu.id,
                    menuType: menu.isCheck ? MenuType.needToRequset.rawValue : MenuType.vegan.rawValue,
                    menu: menu.menu,
                    price: menu.price,
                    howToRequest: menu.howToRequest,
                    isCheck: menu.isCheck
                )
            }
        }
        
        return menuData
    }
    
    private func filteringInsertMenuData(_ isDefaultMenuTable: Bool) -> [AVIROMenu] {
        var insertMenuArray = [AVIROMenu]()
        
        if isDefaultMenuTable {
            insertMenuArrayId.forEach { insertMenu in
                if insertMenu.0 == isDefaultMenuTable {
                    veganMenuArray?.forEach { veganMenu in
                        if insertMenu.1 == veganMenu.id {
                            guard let menu = checkInsertedMenuDataWhenVeganMenu(veganMenu) else { return }
                            
                            insertMenuArray.append(menu)
                        }
                    }
                }
            }
        } else {
            insertMenuArrayId.forEach { insertMenu in
                if insertMenu.0 == isDefaultMenuTable {
                    requestVeganMenuArray?.forEach { veganMenu in
                        if insertMenu.1 == veganMenu.id {
                            guard let menu = checkInsertedMenuDataWhenRequestMenu(veganMenu) else { return }
                            
                            insertMenuArray.append(menu)
                        }
                    }
                }
            }
        }
        
        return insertMenuArray
    }
    
    private func checkInsertedMenuDataWhenVeganMenu(_ menu: VeganTableFieldModelForEdit) -> AVIROMenu? {
        guard let initVeganMenuArray = initVeganMenuArray else { return nil }
        
        var menuData: AVIROMenu?
        
        if !initVeganMenuArray.contains(where: { $0.id == menu.id }) {
            menuData = AVIROMenu(
                menuId: menu.id,
                menuType: MenuType.vegan.rawValue,
                menu: menu.menu,
                price: menu.price,
                howToRequest: "",
                isCheck: false
            )
        }
        
        return menuData
    }
    
    private func checkInsertedMenuDataWhenRequestMenu(_ menu: RequestTableFieldModelForEdit) -> AVIROMenu? {
        guard let initRequestVeganMenuArray = initRequestVeganMenuArray else { return nil }
        
        var menuData: AVIROMenu?
        
        if !initRequestVeganMenuArray.contains(where: { $0.id == menu.id }) {
            menuData = AVIROMenu(
                menuId: menu.id,
                menuType: menu.isCheck ? MenuType.needToRequset.rawValue : MenuType.vegan.rawValue,
                menu: menu.menu,
                price: menu.price,
                howToRequest: menu.howToRequest,
                isCheck: menu.isCheck
            )
        }
        
        return menuData
    }
    
    private func updateMenuData(_ editMenu: AVIROEditMenuModel) {
        guard let isAll = isAll,
              let isSome = isSome,
              let isRequest = isRequest
        else { return }
        
        var mapPlace: MapPlace!
        
        if isAll {
            mapPlace = .All
        } else if isSome {
            mapPlace = .Some
        } else {
            mapPlace = .Request
        }
                

        let editMenuChangedMarkerModel = EditMenuChangedMarkerModel(mapPlace: mapPlace, isAll: isAll, isSome: isSome, isRequest: isRequest)
        
        AVIROAPIManager().postEditMenu(editMenu) { [weak self] result in
            DispatchQueue.main.async {
                print(result)
                if result.statusCode == 200 {
                    self?.viewController?.popViewController()
                    self?.afterEditMenuChangedMenus?()
                    self?.afterEditMenuChangedVeganMarker?(editMenuChangedMarkerModel)
                }
            }
        }
    }
}
