//
//  PlaceListSearchViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

protocol PlaceListProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func reloadTableView()
    func popViewController()
    func popAlertController()
}

final class PlaceListSearchViewPresenter: NSObject {
    weak var viewController: PlaceListProtocol?
    
    private let requestManager = KakaoMapRequestManager()
    
    private var placeList = [PlaceListModel]()
    
    // textColor 변경을 위한 변수
    var inrolledData: String?
    
    // page 추가
    var currentPage = 1
    var isEnd = false
    var isLoading = false
    
    init(viewController: PlaceListProtocol,
         placeList: [PlaceListModel] = []
    ) {
        self.viewController = viewController
        self.placeList = placeList
    }
    
    // MARK: PlaceList 변수 다루기
    var placeListCount: Int {
        return self.placeList.count
    }
    
    func placeListRow(_ row: Int) -> PlaceListModel {
        return placeList[row]
    }
    
    // MARK: ViewDidLoad
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
    }
    
    // MARK: 검색할때 api 호출
    func searchData(_ query: String) {
        currentPage = 1
        let query = query
        let longitude = PersonalLocation.shared.longitudeString
        let latitude = PersonalLocation.shared.latitudeString
        
        requestManager.kakaoMapKeywordSearch(query: query,
                                      longitude: longitude,
                                      latitude: latitude,
                                      page: "\(currentPage)") { [weak self] model in
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

            DispatchQueue.main.async {
                self?.placeList = placeList
                self?.viewController?.reloadTableView()
                self?.isLoading = false
            }
        }
    }
    
    // MARK: 스크롤 할 때 데이터 load 함수
    func loadData(_ query: String) {
        // loding 일 때 api 호출 x
        if isLoading {
            return
        }
        
        isLoading = true
        currentPage += 1
        
        // TODO: page가 마지막 일때 api 호출 x
        if PageEndingCheck.shared.isend == true {
            return
        }
        let query = query
        let longitude = PersonalLocation.shared.longitudeString
        let latitude = PersonalLocation.shared.latitudeString
        
        requestManager.kakaoMapKeywordSearch(query: query,
                                      longitude: longitude,
                                      latitude: latitude,
                                      page: "\(currentPage)") { [weak self] model in
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
            
            DispatchQueue.main.async {
                self?.placeList.append(contentsOf: placeList)
                self?.viewController?.reloadTableView()
                self?.isLoading = false
            }
        }
    }
    
    // MARK: Item 클릭 될 떄
    func didSelectRowAt(_ indexPath: IndexPath) {
        let selectedItem = placeList[indexPath.row]
        
        let placeModel = PlaceCheckModel(
            title: selectedItem.title,
            address: selectedItem.address,
            x: String(selectedItem.x),
            y: String(selectedItem.y)
        )
        
        AVIROAPIManager().getCheckPlace(placeModel: placeModel) { [weak self] checkedPlace in
            
            DispatchQueue.main.async {
                if checkedPlace.registered {
                    self?.viewController?.popAlertController()
                } else {
                    self?.savePlaceModel(selectedItem)
                    self?.viewController?.popViewController()
                }
            }
        }
    }
    
    // MARK: Place Model 저장
    func savePlaceModel(_ selectedPlace: PlaceListModel) {
        let userInfo: [String: Any] = ["selectedPlace": selectedPlace]
        
        NotificationCenter.default.post(
            name: NSNotification.Name("selectedPlace"),
            object: nil,
            userInfo: userInfo
        )
    }
}
