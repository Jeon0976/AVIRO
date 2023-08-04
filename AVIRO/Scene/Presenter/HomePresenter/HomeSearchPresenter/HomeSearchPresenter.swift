//
//  HomeSearchPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

protocol HomeSearchProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func howToShowFirstView(_ isShowHistoryTable: Bool)
}

final class HomeSearchPresenter {
    weak var viewController: HomeSearchProtocol?
    
    private var historyTableArray = [HistoryTableModel]()
    private let userDefaultsManager = UserDefalutsManager()
    
    // MARK: 데이터 변함에 따라 보여지는 view가 다름
    private var haveHistoryTableValues = false {
        didSet {
            viewController?.howToShowFirstView(haveHistoryTableValues)
        }
    }
    
    init(viewController: HomeSearchProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        loadHistoryTableArray()
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
        
    // MARK: HistoryTable local에서 데이터 불러오기
    func loadHistoryTableArray() {
        let loadedHistory = userDefaultsManager.getHistoryModel()
        
        historyTableArray = loadedHistory
        
        CheckHistoryTableValues()
    }
    
    // MARK: Check HistoryTableValues
    func CheckHistoryTableValues() {
        if historyTableArray.isEmpty {
            haveHistoryTableValues = false
        } else {
            haveHistoryTableValues = true
        }
    }
    
    // MARK: HistoryTable에 데이터 저장하고 불러오기
    func appendHistoryModel(_ newHistoryModel: HistoryTableModel) {
        userDefaultsManager.setHistoryModel(newHistoryModel)
        loadHistoryTableArray()
    }
    
    // MARK: HistoryTable에 데이터 삭제하고 불러오기
    func deleteHistoryModel(_ historyModel: HistoryTableModel) {
        userDefaultsManager.deleteHistoryModel(historyModel)
        loadHistoryTableArray()
    }
}
