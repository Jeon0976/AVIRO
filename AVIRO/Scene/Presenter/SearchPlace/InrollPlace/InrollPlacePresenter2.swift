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
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
    func updatePlaceInfo(_ storeInfo: PlaceListModel)
    func allVeganTapped()
    func someVeganTapped()
    func requestVeganTapped()
}

final class InrollPlacePresenter2 {
    weak var viewController: InrollPlaceProtocol2?
    
    private let aviroManager = AVIROAPIManager()
    
    private var storeNomalData: PlaceListModel?
    private var menuArray = [MenuArray]()
    private var category: Category?
    
    private var noRequestFieldModel = [VeganTableFieldModel(menu: "", price: "")]
    private var requestFieldModel = [RequestTableFieldModel(menu: "", price: "", howToRequest: "", isCheck: false)]
    
    var noRequestCount: Int {
        noRequestFieldModel.count
    }
    
    var requestTableCount: Int {
        requestFieldModel.count
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
}
