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
    func reloadTableView(_ checkTable: Bool)
}

final class InrollPlacePresenter: NSObject {
    weak var viewController: InrollPlaceProtocol?
    
    // tableView Cell 개수 데이터 (최초 데이터)
    var notRequestMenu = [NotRequestMenu](repeating: NotRequestMenu(menu: "", price: ""), count: 1)
    var requestMenu = [RequestMenu](repeating: RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false), count: 1)
    
    var storeNomalData: PlaceListModel!
    
    init(viewController: InrollPlaceProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    // MARK: plus button 클릭 시 tableView Cell Data 추가
    func plusCell(_ checkCell: Bool) {
        if checkCell {
            let mockCellData = NotRequestMenu(menu: "", price: "")
            
            notRequestMenu.append(mockCellData)
            notRequestMenu.sort { ($0.hasData, $1.hasData) == (true, false) }
            
            viewController?.reloadTableView(true)
        } else {
            let mockCellData = RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false)
            
            requestMenu.append(mockCellData)
            requestMenu.sort { ($0.hasData, $1.hasData) == (true, false)}

            viewController?.reloadTableView(false)
        }
    }
    
}

