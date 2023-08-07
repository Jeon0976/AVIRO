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
    func placeListTableReload()
    func historyListTableReload()
    func insertTitleToTextField(_ query: String)
    func popViewController()
}

final class HomeSearchPresenter {
    weak var viewController: HomeSearchProtocol?

    private let userDefaultsManager = UserDefalutsManager()
    private var historyPlaceModel = [HistoryTableModel]()
    private var matchedPlaceModel = [MatchedPlaceModel]()
    
    var changedColorText = ""
    
    private var currentPage = 1
    private var isEnd = false
    private var isLoading = false
    
    // MARK: Matched Place List Model 다루기
    var matchedPlaceModelCount: Int {
        matchedPlaceModel.count
    }
    
    func matchedPlaceListRow(_ row: Int) -> MatchedPlaceModel {
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
            viewController?.howToShowFirstView(haveHistoryTableValues)
        }
    }

    // MARK: Start Searching
    var startSearching = false
    
    init(viewController: HomeSearchProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        // MARK: 최근 검색어 데이터 불러오면서 데이터 상태에 따른 view 표시
        loadHistoryTableArray()
        checkHistoryTableValues()
        
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
            
    // TODO: Index 직접 접근하는거 최대한 버그 안 생기도록 코드 수정 필요
    
    // MARK: HistoryTable local에서 데이터 불러오기
    func loadHistoryTableArray() {
        let loadedHistory = userDefaultsManager.getHistoryModel()
        
        historyPlaceModel = loadedHistory
        
        viewController?.historyListTableReload()
    }
    
    // MARK: Check HistoryTableValues
    func checkHistoryTableValues() {
        if historyPlaceModel.isEmpty {
            haveHistoryTableValues = false
        } else {
            haveHistoryTableValues = true
        }
    }
    
    // TODO: textfield 데이터 지우고 클릭할 떄
    // MARK: HistoryTable에 데이터 저장하고 불러오기
    func insertHistoryModel(_ indexPath: IndexPath) {
        let title = matchedPlaceModel[indexPath.row].title
        let historyModel = HistoryTableModel(title: title)
        userDefaultsManager.setHistoryModel(historyModel)
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
        
        viewController?.insertTitleToTextField(title)
    }
    
    // MARK: 최초 Search 후 KakaoMap Load -> AVIRO 데이터 비교
    func initialSearchDataAndCompareAVIROData(_ query: String) {
        matchedPlaceModel.removeAll()
        
        initalSearchData(query: query) { [weak self] placeList in
            self?.makeToPlaceFromAVIROData(placeList: placeList)
        }
    }
    
    // MARK: 검색 후 KakaoMap Location Search API 호출
    private func initalSearchData(
        query: String,
        completion: @escaping ([PlaceListModel]) -> Void
    ) {
        currentPage = 1
        let query = query
        
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
        
        
        KakaoMapRequestManager().kakaoMapLocationSearch(
            query: query,
            longitude: String(longitude),
            latitude: String(latitude),
            page: "\(currentPage)",
            isAccuracy: KakaoAPISortingQuery.shared.sorting
        ) { model in
            let placeList = model.documents.map { location in
                let placeListCellModel = PlaceListModel(
                    title: location.name,
                    distance: location.distance,
                    address: location.address,
                    phone: location.phone,
                    url: location.url,
                    x: Double(location.xToLongitude)!,
                    y: Double(location.yToLatitude)!
                )
                return placeListCellModel
            }
            
            PageEndingCheck.shared.isend = model.meta.isEnd
            
            completion(placeList)
        }
    }
    
    // MARK: Paging후 KakaoMap Load -> AVIRO 데이터 비교
    func afterPagingSearchAndCompareAVIROData(_ query: String) {
        pagingSearchData(query: query) { [weak self] placeList in
            self?.makeToPlaceFromAVIROData(placeList: placeList)
        }
    }
    
    // MARK: Paging후 KakaoMap Location Search API 호출
    private func pagingSearchData(query: String, completion: @escaping ([PlaceListModel]) -> Void
    ) {
        if isLoading {
            return
        }
        
        isLoading = true
        currentPage += 1
        
        if PageEndingCheck.shared.isend == true {
            return
        }
  
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
        
        KakaoMapRequestManager().kakaoMapLocationSearch(
            query: query,
            longitude: String(longitude),
            latitude: String(latitude),
            page: "\(currentPage)",
            isAccuracy: KakaoAPISortingQuery.shared.sorting
        ) { model in
                let placeList = model.documents.map { location in
                    let placeListCellModel = PlaceListModel(
                        title: location.name,
                        distance: location.distance,
                        address: location.address,
                        phone: location.phone,
                        url: location.url,
                        x: Double(location.xToLongitude)!,
                        y: Double(location.yToLatitude)!
                    )
                    return placeListCellModel
                }
                
                PageEndingCheck.shared.isend = model.meta.isEnd
                
                completion(placeList)
            }
    }
    
    // MARK: AVIRO 데이터와 비교하기 위한 데이터 만들기
    private func makeToPlaceFromAVIROData(placeList: [PlaceListModel]) {
        var beforeMatchedArray = [ForMatchedAVIRO]()
        var afterMatchedArray = [AfterMatchedAVIRO]()
        
        placeList.forEach {
            let title = $0.title
            let address = $0.address
            let x = $0.x
            let y = $0.y
            let model = ForMatchedAVIRO(
                title: title,
                address: address,
                x: x,
                y: y
            )
            
            beforeMatchedArray.append(model)
        }
                
        let beforeMatchedRequestModel = PlaceModelBeforeMatchedAVIRO(placeArray: beforeMatchedArray)
        AVIROAPIManager().postPlaceListMatched(beforeMatchedRequestModel) { placeModelAfterMatched in
            afterMatchedArray = placeModelAfterMatched.body
            DispatchQueue.main.async { [weak self] in
                self?.bindingToTableData(
                    afterMatched: afterMatchedArray,
                    placeList: placeList)
            }
        }
    }
    
    // MARK: 비교 기반 데이터로 table 데이터에 바인딩
    // TODO: 오류 및 API 호출 관련해서 다 입력 끝나면 발동하게 수정??
    private func bindingToTableData(
        afterMatched: [AfterMatchedAVIRO],
        placeList: [PlaceListModel]
    ) {
        for (index, place) in placeList.enumerated() {
            let matched = afterMatched.first(where: { $0.index == index})
            
            let matchedPlace = MatchedPlaceModel(
                title: place.title,
                distance: place.distance,
                address: place.address,
                allVegan: matched?.allVegan == 1 ? true : false,
                someVegan: matched?.someMenuVegan == 1 ? true : false,
                requestVegan: matched?.ifRequestVegan == 1 ? true : false,
                x: place.x,
                y: place.y
            )

            matchedPlaceModel.append(matchedPlace)
        }

        viewController?.placeListTableReload()
        isLoading = false
    }
    
    func checkIsInAVIRO(_ indexPath: IndexPath) {
        let model = matchedPlaceModel[indexPath.row]

        let userInfo: [String: Any] = ["checkIsInAVRIO": model]

        NotificationCenter.default.post(
            name: NSNotification.Name("checkIsInAVRIO"),
            object: nil,
            userInfo: userInfo
        )
        
        viewController?.popViewController()
    }
}
