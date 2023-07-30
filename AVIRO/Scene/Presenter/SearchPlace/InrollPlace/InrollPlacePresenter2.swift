//
//  InrollPlacePresenter2.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

protocol InrollPlaceProtocol2: NSObject {
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
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
}

// TODO: Dictionary로 데이터 구조 변경해서 binding 하기
final class InrollPlacePresenter2 {
    weak var viewController: InrollPlaceProtocol2?
        
    private var storeNomalData: PlaceListModel?
    private var menuArray = [MenuArray]()
    private var category: Category?
    
    private var normalTableModel = [VeganTableFieldModel(menu: "", price: "")]
    private var requestTableModel = [RequestTableFieldModel(menu: "", price: "", howToRequest: "", isCheck: false)]
    
    private var LastModel: VeganModel?
    
    var normalTableCount: Int {
        normalTableModel.count
    }
    
    var requestTableCount: Int {
        requestTableModel.count
    }
    
    var allVegan = false
    var someMenuVagen = false
    var ifRequestVegan = false
    
    var isPresentingDefaultTable = true
    
    init(viewController: InrollPlaceProtocol2) {
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
        viewController?.keyboardWillShow(notification: notification)
    }
    
    @objc func keyboardWillHide() {
        viewController?.keyboardWillHide()
    }
    
    // MARK: After Serach
    func updatePlaceModel(_ model: PlaceListModel) {
        storeNomalData = model
        
        guard let storeInfo = storeNomalData else { return }
        
        viewController?.updatePlaceInfo(storeInfo)
    }
    
    // MARK: Category Button 클릭 시
    func categoryTapped(_ title: String) {
        switch title {
        case Category.restaurant.title:
            category = Category.restaurant
        case Category.cafe.title:
            category = Category.cafe
        case Category.bakery.title:
            category = Category.bakery
        case Category.bar.title:
            category = Category.bar
        default:
            category = nil
        }
    }
    
    // MARK: Vegan Option Button 클릭 시
    func veganOptionButtonTapped(_ button: VeganOptionButton) {
        guard let title = button.titleLabel?.text else { return }
        
        if title == VeganOption.allVegan.value {
            viewController?.allVeganTapped()
        } else {
            switch title {
            case VeganOption.someVegan.value:
                viewController?.someVeganTapped()
            case VeganOption.requestVegan.value:
                viewController?.requestVeganTapped()
            default:
                break
            }
        }
    }
    
    // MARK: Menu Plus Button 클릭 시
    func menuPlusButtonTapped() {
        if isPresentingDefaultTable {
            let dummyNormal = VeganTableFieldModel(menu: "", price: "")
            normalTableModel.append(dummyNormal)
        } else {
            let dummyRequest = RequestTableFieldModel(menu: "", price: "", howToRequest: "", isCheck: false)
            requestTableModel.append(dummyRequest)
        }
        
        viewController?.menuTableReload(isPresentingDefaultTable: isPresentingDefaultTable)
    }
    
    // MARK: Normal Table Cell
    func normalTableCell (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NormalTableViewCell.identifier, for: indexPath) as? NormalTableViewCell
        let data =  normalTableModel[indexPath.row]
        
        cell?.setData(menu: data.menu, price: data.price)
        
        cell?.editingMenuField = { [weak self] menu in
            self?.bindingNormalMenuData(menu, indexPath)
        }
        
        cell?.editingPriceField = { [weak self] price in
            self?.bindingNormalPriceData(price, indexPath)
        }
        
        cell?.priceField.variblePriceChanged = { [weak self] price in
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
        
        print(data)
        
        cell?.setData(menu: data.menu,
                      price: data.price,
                      request: data.howToRequest,
                      isSelected: data.isCheck
        )
        
        cell?.editingMenuField = { [weak self] menu in
            self?.bindingRequestMenu(menu, indexPath)
        }
        
        cell?.editingPriceField = { [weak self] price in
            self?.bindingRequestPrice(price, indexPath)
        }
        
        cell?.priceField.variblePriceChanged = { [weak self] price in
            self?.bindingRequestPrice(price, indexPath)
        }
        
        cell?.editingRequestField = { [weak self] request in
            self?.bindingRequestField(request, indexPath)
        }
        
        cell?.onRequestButtonTapped = { [weak self] active in
            self?.bindingRequestActiviate(active, indexPath)
        }
        
        cell?.onMinusButtonTapped = { [weak self] in
            self?.deleteRequestData(indexPath)
        }

        return cell ?? UITableViewCell()
    }
    
    // MARK: Binding Normal Data
    func bindingNormalMenuData(_ menu: String, _ indexPath: IndexPath) {
        normalTableModel[indexPath.row].menu = menu
    }
    
    func bindingNormalPriceData(_ price: String, _ indexPath: IndexPath) {
        normalTableModel[indexPath.row].price = price
    }
    
    func deleteNormalData(_ indexPath: IndexPath) {
        normalTableModel.remove(at: indexPath.row)
        viewController?.menuTableReload(isPresentingDefaultTable: true)
    }
    
    // MARK: Binding Request Data
    func bindingRequestMenu(_ menu: String, _ indexPath: IndexPath) {
        requestTableModel[indexPath.row].menu = menu
    }
    
    func bindingRequestPrice(_ price: String, _ indexPath: IndexPath) {
        requestTableModel[indexPath.row].price = price
    }
    
    func bindingRequestField(_ request: String, _ indexPath: IndexPath) {
        requestTableModel[indexPath.row].howToRequest = request
        print(requestTableModel)
    }
    
    func bindingRequestActiviate(_ active: Bool, _ indexPath: IndexPath) {
        requestTableModel[indexPath.row].isCheck = active
    }
    
    func deleteRequestData(_ indexPath: IndexPath) {
        requestTableModel.remove(at: indexPath.row)
        viewController?.menuTableReload(isPresentingDefaultTable: false)
    }
}
