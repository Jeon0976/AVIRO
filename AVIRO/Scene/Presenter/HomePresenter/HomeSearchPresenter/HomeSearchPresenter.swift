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
    func reloadTableView()
}

final class HomeSearchPresenter {
    weak var viewController: HomeSearchProtocol?

    private let userDefaultsManager = UserDefalutsManager()
    private var historyTableArray = [HistoryTableModel]()
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
        let longitude = PersonalLocation.shared.longitudeString
        let latitude = PersonalLocation.shared.latitudeString
        
        KakaoMapRequestManager().kakaoMapLocationSearch(
            query: query,
            longitude: longitude,
            latitude: latitude,
            page: "\(currentPage)"
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
        
        let query = query
        let longitude = PersonalLocation.shared.longitudeString
        let latitude = PersonalLocation.shared.latitudeString
        
        KakaoMapRequestManager().kakaoMapLocationSearch(
            query: query,
            longitude: longitude,
            latitude: latitude,
            page: "\(currentPage)") { model in
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
                requestVegan: matched?.ifRequestVegan == 1 ? true : false
            )

            matchedPlaceModel.append(matchedPlace)
        }

        viewController?.reloadTableView()
        isLoading = false
    }
}
