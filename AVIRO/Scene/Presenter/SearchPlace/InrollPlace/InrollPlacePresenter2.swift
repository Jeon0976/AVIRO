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
    func makeGesture()
    func makeNotification()
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
    
    init(viewController: InrollPlaceProtocol2) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeGesture()
        viewController?.makeNotification()
    }
    
    func viewWillAppear() {
        viewController?.makeAttribute()
    }
    
    func updatePlaceModel(_ model: PlaceListModel) {
        storeNomalData = model
    }
    
    func updateCategory(_ category: Category?) {
        self.category = category
    }
}
