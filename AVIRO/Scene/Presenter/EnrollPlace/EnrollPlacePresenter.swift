//
//  InrollPlacePresenter2.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

protocol EnrollPlaceProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeAttributeWhenViewWillAppear()
    func makeGesture()
    func makeNotification()
    func updatePlaceInfo(_ storeInfo: PlaceListModel)
    func allVeganTapped()
    func someVeganTapped()
    func requestVeganTapped()
    func menuTableReload(isPresentingDefaultTable: Bool)
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func enableRightButton(_ bool: Bool)
    func popViewController()
    func pushAlertController()
}

final class EnrollPlacePresenter {
    weak var viewController: EnrollPlaceProtocol?
        
    private var storeNormalData: PlaceListModel?
    private var category: PlaceCategory?
    
    private var normalTableModel = [
        VeganTableFieldModel(
            menu: "",
            price: ""
        )
    ]
    private var requestTableModel = [
        RequestTableFieldModel(
            menu: "",
            price: "",
            howToRequest: "",
            isCheck: false,
            isEnabled: true
        )
    ]
    
    var normalTableCount: Int {
        normalTableModel.count
    }
    
    var requestTableCount: Int {
        requestTableModel.count
    }
    
    private var allVegan = false
    private var someVegan = false
    private var requestVegan = false {
        didSet {
            if requestVegan && !someVegan {
                fixedRequestTable()
            } else {
                unFixedRequestTable()
            }
        }
    }
    
    // MARK: Menu Table
    var isPresentingDefaultTable = true
    
    // MARK: Data에 맞춰서 등록하기 활성화를 위한 Dictionary
    private var totalData: [String: Any?] = [
        "storeNormalData": false,
        "category": false,
        "allVegan": false,
        "someVegan": false,
        "requestVegan": false,
        "normalTableModel": nil,
        "requestTableModel": nil
    ]
    
    // MARK: 최종 데이터
    private var veganModel: AVIROEnrollPlaceDTO?
    
    init(viewController: EnrollPlaceProtocol) {
        self.viewController = viewController
    }
    
    // MARK: View Did Load
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeGesture()
        viewController?.makeNotification()
        viewController?.makeAttribute()
    }
    
    // MARK: View Will Appear
    func viewWillAppear() {
        viewController?.makeAttributeWhenViewWillAppear()
        addKeyboardNotification()
    }
    
    // MARK: View Will Disappear
    func viewWillDisappear() {
        removeKeyboardNotification()
    }

    // MARK: Report Store
    func reportStore() {
        guard let veganModel = veganModel else {
            return
        }
         
        // TODO: 수정 예정
        AVIROAPIManager().postPlaceModel(veganModel) { [weak self] responseModel in
            DispatchQueue.main.async {
                if responseModel.statusCode == 200 {
                    self?.viewController?.popViewController()
                } else {
                    self?.viewController?.pushAlertController()
                }
            }
        }
    }
    
    // MARK: Init Data
    func initData() {
        storeNormalData = nil
        category = nil
        normalTableModel = [
            VeganTableFieldModel(
                menu: "",
                price: "")
        ]
        requestTableModel = [
            RequestTableFieldModel(
                menu: "",
                price: "",
                howToRequest: "",
                isCheck: false,
                isEnabled: true)
        ]
        allVegan = false
        someVegan = false
        requestVegan = false
        
        isPresentingDefaultTable = true
        
        totalData = [
            "storeNormalData": false,
            "category": false,
            "allVegan": false,
            "someVegan": false,
            "requestVegan": false,
            "normalTableModel": nil,
            "requestTableModel": nil
        ]
        
        veganModel = nil
    }
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    func addKeyboardNotification() {
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
    
    func removeKeyboardNotification() {
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            viewController?.keyboardWillShow(height: keyboardRectangle.height)
        }
    }
    
    @objc func keyboardWillHide() {
        viewController?.keyboardWillHide()
    }
    
    // MARK: After Serach
    func updatePlaceModel(_ model: PlaceListModel) {
        storeNormalData = model
        
        guard let storeInfo = storeNormalData else { return }
        updateData(key: "storeNormalData", value: true)
        viewController?.updatePlaceInfo(storeInfo)
    }
    
    // MARK: Category Button 클릭 시
    func categoryTapped(_ title: String) {
        switch title {
        case PlaceCategory.restaurant.title:
            category = PlaceCategory.restaurant
        case PlaceCategory.cafe.title:
            category = PlaceCategory.cafe
        case PlaceCategory.bakery.title:
            category = PlaceCategory.bakery
        case PlaceCategory.bar.title:
            category = PlaceCategory.bar
        default:
            category = nil
        }
        updateData(key: "category", value: true)
    }
    
    // MARK: Vegan Option Button 클릭 시
    func veganOptionButtonTapped(_ button: VeganOptionButton) {
        guard let title = button.titleLabel?.text else { return }
    
        if title == VeganOption.all.buttontitle {
            viewController?.allVeganTapped()
        } else {
            switch title {
            case VeganOption.some.buttontitle:
                viewController?.someVeganTapped()
            case VeganOption.request.buttontitle:
                viewController?.requestVeganTapped()
            default:
                break
            }
        }
    }
    
    // MARK: Button Data Binding
    func changeButton(allVegan: Bool,
                      someVegan: Bool,
                      requestVegan: Bool
    ) {
        self.allVegan = allVegan
        self.someVegan = someVegan
        self.requestVegan = requestVegan

        let keys = ["allVegan", "someVegan", "requestVegan"]
        let values = [allVegan, someVegan, requestVegan]
        
        updateButtonBools(keys: keys, values: values)
        
        if requestVegan {
            updateData(key: "requestTableModel", value: self.requestTableModel)
        }
    }
    
    // MARK: Menu Plus Button 클릭 시
    func menuPlusButtonTapped() {
        if isPresentingDefaultTable {
            plusNormalTable()
        } else {
            plusRequestTable()
        }
        
        viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
    }
    
    // MARK: Plus Normal Table
    private func plusNormalTable() {
        let dummyNormal = VeganTableFieldModel(menu: "", price: "")
        normalTableModel.append(dummyNormal)
        updateData(key: "normalTableModel", value: self.normalTableModel)
    }
    
    // MARK: Plus Request Table
    private func plusRequestTable() {
        let dummyRequest: RequestTableFieldModel!
        
        if requestVegan && !someVegan {
            dummyRequest = RequestTableFieldModel(
                menu: "",
                price: "",
                howToRequest: "",
                isCheck: true,
                isEnabled: false
            )
        } else {
            dummyRequest = RequestTableFieldModel(
                menu: "",
                price: "",
                howToRequest: "",
                isCheck: false,
                isEnabled: true
            )
        }
        
        requestTableModel.append(dummyRequest)
        updateData(
            key: "requestTableModel",
            value: self.requestTableModel
        )
    }
    
    // MARK: Request Table 자동 check On & Off
    private func fixedRequestTable() {
        for index in requestTableModel.indices {
            requestTableModel[index].isCheck = true
            requestTableModel[index].isEnabled = false
        }
        viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
    }
    
    private func unFixedRequestTable() {
        for index in requestTableModel.indices {
            requestTableModel[index].isEnabled = true
        }
        viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
    }
    // MARK: Normal Table Cell
    func normalTableCell (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NormalTableViewCell.identifier,
            for: indexPath
        ) as? NormalTableViewCell
        
        let data =  normalTableModel[indexPath.row]
        
        cell?.setData(menu: data.menu, price: data.price)
        
        cell?.editingMenuField = { [weak self] menu in
            self?.bindingNormalMenuData(menu, indexPath)
        }
        
        cell?.editingPriceField = { [weak self] price in
            self?.bindingNormalPriceData(price, indexPath)
        }
        
        cell?.priceField.variablePriceChanged = { [weak self] price in
            self?.bindingNormalPriceData(price, indexPath)
        }
        
        cell?.onMinusButtonTapped = { [weak self] in
            self?.deleteNormalData(indexPath)
        }
        
        return cell ?? UITableViewCell()
    }
    
    // MARK: Request Table Cell
    func requestTableCell (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RequestTableViewCell.identifier,
            for: indexPath
        ) as? RequestTableViewCell
        
        let data = requestTableModel[indexPath.row]
                
        cell?.setData(menu: data.menu,
                      price: data.price,
                      request: data.howToRequest,
                      isSelected: data.isCheck,
                      isEnabled: data.isEnabled
        )
        
        cell?.editingMenuField = { [weak self] menu in
            self?.bindingRequestMenu(menu, indexPath)
        }
        
        cell?.editingPriceField = { [weak self] price in
            self?.bindingRequestPrice(price, indexPath)
        }
        
        cell?.priceField.variablePriceChanged = { [weak self] price in
            self?.bindingRequestPrice(price, indexPath)
        }
        
        cell?.editingRequestField = { [weak self] request in
            self?.bindingRequestField(request, indexPath)
        }
        
        cell?.onRequestButtonTapped = { [weak self] active in
            self?.bindingRequestActiviate(active, indexPath)
        }
        
        cell?.onMinusButtonTapped = { [weak self] in
            self?.deleteRequestCell(indexPath)
        }

        return cell ?? UITableViewCell()
    }
}

extension EnrollPlacePresenter {
    // MARK: Data 추가 될 때 마다 발동
   private func updateData(key: String, value: Any?) {
        totalData[key] = value
        checkAllDataIsFilled()
    }
    
    // MARK: Button 클릭 될 때마다 최신값 All Data is Filled의 최신화
   private func updateButtonBools(keys: [String], values: [Bool]) {
        for i in 0..<keys.count {
            totalData[keys[i]] = values[i]
        }
        checkAllDataIsFilled()
    }
    
    // MARK: Filled 가능한지 체크 함수
    private func checkAllDataIsFilled() {
        guard ((totalData["storeNormalData"] as? Bool?) ?? false) == true else {
            viewController?.enableRightButton(false)
            return
        }
        
        guard ((totalData["category"] as? Bool?) ?? false) == true else {
            viewController?.enableRightButton(false)
            return
        }
        
        let allVegan = totalData["allVegan"] as? Bool ?? false
        let someVegan = totalData["someVegan"] as? Bool ?? false
        let requestVegan = totalData["requestVegan"] as? Bool ?? false
        
        guard allVegan || someVegan || requestVegan else {
            viewController?.enableRightButton(false)
            return
        }
        
        veganModel = AVIROEnrollPlaceDTO(
            userId: MyData.my.id,
            title: storeNormalData?.title ?? "",
            category: category?.title ?? "",
            address: storeNormalData?.address ?? "",
            phone: storeNormalData?.phone ?? "",
            x: storeNormalData?.x ?? 0.0,
            y: storeNormalData?.y ?? 0.0,
            allVegan: allVegan,
            someMenuVegan: someVegan,
            ifRequestVegan: requestVegan
        )
        
        let normalTableModel = totalData["normalTableModel"] as? [VeganTableFieldModel] ?? []
        let requestTableModel = totalData["requestTableModel"] as? [RequestTableFieldModel] ?? []
        
        var menuArray: [AVIROMenu] = []
                
        if isPresentingDefaultTable {
            let hasEmptyData = normalTableModel.contains { $0.menu == "" || $0.price == ""} || normalTableModel.isEmpty
            guard !hasEmptyData else {
                viewController?.enableRightButton(false)
                return
            }
            normalTableModel.forEach {
                let menu = AVIROMenu(
                    menuType: MenuType.vegan.rawValue,
                    menu: $0.menu,
                    price: $0.price,
                    howToRequest: "",
                    isCheck: false
                )
                menuArray.append(menu)
            }
            
            veganModel?.menuArray = menuArray
        } else {
            let hasEmptyData = requestTableModel.contains { $0.menu == "" || $0.price == ""} || requestTableModel.isEmpty
            guard !hasEmptyData else {
                viewController?.enableRightButton(false)
                return
            }
            
            let hasEmptyRequest = requestTableModel.contains {
                return $0.isCheck && $0.howToRequest == ""
            }

            guard !hasEmptyRequest else {
                viewController?.enableRightButton(false)
                return
            }
            
            requestTableModel.forEach {
                let menu = AVIROMenu(
                    menuType: $0.isCheck ? MenuType.needToRequset.rawValue : MenuType.vegan.rawValue,
                    menu: $0.menu,
                    price: $0.price,
                    howToRequest: $0.howToRequest,
                    isCheck: $0.isCheck
                )
                
                menuArray.append(menu)
            }
            
            veganModel?.menuArray = menuArray
        }
        
        viewController?.enableRightButton(true)
    }
    
    // MARK: Binding Normal Data
    private func bindingNormalMenuData(_ menu: String, _ indexPath: IndexPath) {
        normalTableModel[indexPath.row].menu = menu
        updateData(key: "normalTableModel", value: self.normalTableModel)
    }
    
    private func bindingNormalPriceData(_ price: String, _ indexPath: IndexPath) {
        normalTableModel[indexPath.row].price = price
        updateData(key: "normalTableModel", value: self.normalTableModel)
    }
    
    private func deleteNormalData(_ indexPath: IndexPath) {
        if normalTableModel.count > 1 {
            normalTableModel.remove(at: indexPath.row)
            viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
            updateData(key: "normalTableModel", value: self.normalTableModel)
        } else {
           return
        }
    }
    
    // MARK: Binding Request Data
    private func bindingRequestMenu(_ menu: String, _ indexPath: IndexPath) {
        requestTableModel[indexPath.row].menu = menu
        updateData(key: "requestTableModel", value: self.requestTableModel)
    }
    
    private func bindingRequestPrice(_ price: String, _ indexPath: IndexPath) {
        requestTableModel[indexPath.row].price = price
        updateData(key: "requestTableModel", value: self.requestTableModel)
    }
    
    private func bindingRequestField(_ request: String, _ indexPath: IndexPath) {
        requestTableModel[indexPath.row].howToRequest = request
        
        updateData(key: "requestTableModel", value: self.requestTableModel)
    }
    
    private func bindingRequestActiviate(_ active: Bool, _ indexPath: IndexPath) {
        if !active {
            deleteOnlyRequestString(indexPath)
        }
        requestTableModel[indexPath.row].isCheck = active
        
        updateData(key: "requestTableModel", value: self.requestTableModel)
    }
    
    private func deleteRequestCell(_ indexPath: IndexPath) {
        if requestTableModel.count > 1 {
            requestTableModel.remove(at: indexPath.row)
            viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
            updateData(key: "requestTableModel", value: self.requestTableModel)
        } else {
            return
        }
    }
    
    private func deleteOnlyRequestString(_ indexPath: IndexPath) {
        requestTableModel[indexPath.row].howToRequest = ""
        updateData(key: "requestTableModel", value: self.requestTableModel)
        viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
    }
}
