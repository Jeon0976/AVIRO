//
//  HomeSearchPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

protocol HomeSearchProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    
    func howToShowViewWhenViewWillAppear(_ isShowHistoryTable: Bool)
    
    func historyListTableReload()
    func afterDidSelectedHistoryCell(_ query: String)

    func activeIndicatorView()
    func placeListNoResultData()
    func placeListTableReloadData()

    func popViewController()
    
    func showErrorAlert(with error: String, title: String?)
}

final class HomeSearchPresenter {
    weak var viewController: HomeSearchProtocol?

    private let userDefaultsManager = SearchHistoryManager()
    
    private var historyPlaceModel = [HistoryTableModel]()
    private var matchedPlaceModel = [MatchedPlaceModel]()
    
    lazy var query = "" {
        didSet {
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(
                timeInterval: 0.4,
                target: self,
                selector: #selector(afterInputData),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    @objc private func afterInputData() {
        self.viewController?.activeIndicatorView()
        self.initSearchDataAndCompareAVIROData(query)
    }
    
    var selectedPlace: ((String) -> Void)?
    
    private var currentPage = 1
    private var isEnding = false
    private var isLoading = false
    private var isEndCompare = false
    
    private var timer: Timer?
    
    // MARK: Matched Place List Model 다루기
    var matchedPlaceModelCount: Int {
        matchedPlaceModel.count
    }
    
    func matchedPlaceListRow(_ row: Int) -> MatchedPlaceModel? {
        guard isEndCompare else { return nil }
        
        return matchedPlaceModel[row]
    }
    
    // MARK: History Place Model List Model 다루기
    var historyPlaceModelCount: Int {
        historyPlaceModel.count
    }
    
    func historyPlaceListRow(_ row: Int) -> HistoryTableModel {
        
        return historyPlaceModel[row]
    }

    // MARK: 데이터 변함에 따라 보여지는 view가 다름
    private (set) var haveHistoryTableValues = false {
        didSet {
            viewController?.howToShowViewWhenViewWillAppear(haveHistoryTableValues)
        }
    }
    
    init(viewController: HomeSearchProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        loadHistoryTableArray()
        checkHistoryTableValues()
        
        viewController?.setupLayout()
        viewController?.setupAttribute()
    }
                
    private func loadHistoryTableArray() {
        let loadedHistory = userDefaultsManager.getHistoryModel()
        
        historyPlaceModel = loadedHistory
        
        viewController?.historyListTableReload()
    }
    
    func checkHistoryTableValues() {
        if historyPlaceModel.isEmpty {
            haveHistoryTableValues = false
        } else {
            haveHistoryTableValues = true
        }
    }
    
    // MARK: HistoryTable에 데이터 저장하고 불러오기
    func insertHistoryModel(_ indexPath: IndexPath) {
        if isEndCompare {
            let title = matchedPlaceModel[indexPath.row].title
            let historyModel = HistoryTableModel(title: title)
            userDefaultsManager.setHistoryModel(historyModel)
        }
    }
    
    // MARK: HistoryTable에 데이터 삭제하고 불러오기
    func deleteHistoryModel(_ indexPath: IndexPath) {
        let historyModel = historyPlaceModel[indexPath.row]
        
        userDefaultsManager.deleteHistoryModel(historyModel)
        loadHistoryTableArray()
    }
    
    // MARK: HistoryTable 전체 삭제하기
    func deleteHistoryModelAll() {
        userDefaultsManager.deleteHistoryModelAll()
        loadHistoryTableArray()
    }
    
    func historyTableCellTapped(_ indexPath: IndexPath) {
        let title = historyPlaceModel[indexPath.row].title
        
        viewController?.afterDidSelectedHistoryCell(title)
    }
    
    // MARK: 최초 Search 후 KakaoMap Load -> AVIRO 데이터 비교
    func initSearchDataAndCompareAVIROData(_ query: String) {
        if query == "" {
            return
        }
        isEndCompare = false
        matchedPlaceModel.removeAll()
        
        initialSearchData(query: query) { [weak self] placeList in
            self?.makeToPlaceFromAVIROData(placeList: placeList)
        }
        
    }
    
    // MARK: Paging후 KakaoMap Load -> AVIRO 데이터 비교
    func afterPagingSearchAndCompareAVIROData(_ query: String) {
        pagingSearchData(query: query) { [weak self] placeList in
            self?.makeToPlaceFromAVIROData(placeList: placeList)
        }
    }
    
    private func initialSearchData(
        query: String,
        completion: @escaping ([PlaceListModel]) -> Void
    ) {
        AmplitudeUtility.searchPlace(with: query)
        
        currentPage = 1
        isEnding = false
        searchPlaceData(query: query, page: currentPage, completion: completion)
    }
    
    private func pagingSearchData(
        query: String,
        completion: @escaping ([PlaceListModel]) -> Void
    ) {
        currentPage += 1
        searchPlaceData(query: query, page: currentPage, completion: completion)
    }
    
    private func searchPlaceData(
        query: String,
        page: Int,
        completion: @escaping ([PlaceListModel]) -> Void
    ) {
        if isEnding || isLoading {
            return
        }
        
        isLoading = true
        
        var longitude: Double
        var latitude: Double
        
        let whichLocation = KakaoAPISortingQuery.shared.coordinate
        
        if whichLocation == KakaoSerachCoordinate.MyCoordinate {
            longitude = MyCoordinate.shared.longitude ?? 0.0
            latitude = MyCoordinate.shared.latitude ?? 0.0
        } else {
            longitude = CenterCoordinate.shared.longitude ?? 0.0
            latitude = CenterCoordinate.shared.latitude ?? 0.0
        }
        
        let model = KakaoKeywordSearchDTO(
            query: query,
            lng: String(longitude),
            lat: String(latitude),
            page: "\(page)",
            isAccuracy: KakaoAPISortingQuery.shared.sorting
        )
        
        KakaoAPIManager().allSearchPlace(with: model) { [weak self] result in
            switch result {
            case .success(let model):
                let placeList = model.documents.map { location in
                    PlaceListModel(
                        title: location.name,
                        distance: location.distance,
                        address: location.address,
                        phone: location.phone,
                        x: Double(location.xToLongitude)!,
                        y: Double(location.yToLatitude)!
                    )
                }
                
                self?.isEnding = model.meta.isEnd
                
                completion(placeList)
                
            case .failure(let error):
                self?.isLoading = false

                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: nil)
                }
            }
        }
    }
    
    // MARK: AVIRO 데이터와 비교하기 위한 데이터 만들기
    private func makeToPlaceFromAVIROData(placeList: [PlaceListModel]) {
        var beforeMatchedArray = [AVIROForMatchedModel]()
        
        placeList.forEach {
            let title = $0.title
            let x = $0.x
            let y = $0.y
            
            let model = AVIROForMatchedModel(
                title: title,
                x: x,
                y: y
            )
            
            beforeMatchedArray.append(model)
        }
                
        let beforeMatchedRequestModel = AVIROBeforeComparePlaceDTO(placeArray: beforeMatchedArray)
                
        print(beforeMatchedRequestModel)
        AVIROAPIManager().checkPlaceList(with: beforeMatchedRequestModel) { [weak self] result in
            switch result {
            case .success(let model):
                if model.statusCode == 200 {
                    self?.bindingToTableData(afterMatched: model.body, placeList: placeList)
                } else {
                    self?.isLoading = false
                    self?.isEndCompare = true
                    self?.viewController?.showErrorAlert(with: "", title: "비교 에러")
                }
            case .failure(let error):
                self?.isLoading = false
                self?.isEndCompare = true
                
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: nil)
                }
            }
        }
    }
    
    // MARK: 비교 기반 데이터로 table 데이터에 바인딩
    private func bindingToTableData(
        afterMatched: [AVIROAfterMatchedModel],
        placeList: [PlaceListModel]
    ) {
        defer {
            isEndCompare = true
            isLoading = false
        }
        for (index, place) in placeList.enumerated() {
            let matched = afterMatched.first(where: { $0.index == index})
            
            let roundedX = Double(round(1000 * place.x) / 1000)
            let roundedY = Double(round(1000 * place.y) / 1000)

            let matchedPlace = MatchedPlaceModel(
                placeId: matched?.placeId ?? "",
                title: place.title,
                distance: place.distance,
                address: place.address,
                allVegan: matched?.allVegan ?? false,
                someVegan: matched?.someMenuVegan ?? false,
                requestVegan: matched?.ifRequestVegan ?? false,
                x: roundedX,
                y: roundedY
            )

            matchedPlaceModel.append(matchedPlace)
        }

        if matchedPlaceModel.count == 0 {
            viewController?.placeListNoResultData()
            
        } else {
            viewController?.placeListTableReloadData()
        }
    }
    
    // 선택된 것이 AVIRO에 있는지 확인하는 함수
    func afterMainSearch(_ indexPath: IndexPath) {
        if isEndCompare {
            let model = matchedPlaceModel[indexPath.row]

            let userInfo: [String: Any] = [NotiName.afterMainSearch.rawValue: model]

            NotificationCenter.default.post(
                name: NSNotification.Name(NotiName.afterMainSearch.rawValue),
                object: nil,
                userInfo: userInfo
            )
            
            selectedPlace?(model.title)
            viewController?.popViewController()
        }
    }
}
