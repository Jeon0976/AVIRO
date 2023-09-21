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
    func noResultData()
    func popViewController()
    func pushAlertController()
}

final class PlaceListSearchViewPresenter: NSObject {
    weak var viewController: PlaceListProtocol?
        
    private var placeList = [PlaceListModel]()
    
    // textColor 변경을 위한 변수
    var inrolledData: String?
    
    // page 추가
    private var currentPage = 1
    private var isEnd = false
    private var isLoading = false
    
    init(viewController: PlaceListProtocol
    ) {
        self.viewController = viewController
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
    
    // MARK: 검색 후 KakaoMap Place Search API 호출
    func searchData(_ query: String) {
        currentPage = 1
        let query = query
        let longitude = MyCoordinate.shared.longitudeString
        let latitude = MyCoordinate.shared.latitudeString
        
        KakaoMapAPIManager().kakaoMapKeywordSearch(query: query,
                                      longitude: longitude,
                                      latitude: latitude,
                                      page: "\(currentPage)") { [weak self] model in
            let placeList = model.documents.map { location in
                let placeListCellModel = PlaceListModel(
                    title: location.name,
                    distance: location.distance,
                    address: location.address,
                    phone: location.phone,
                    x: Double(location.xToLongitude)!,
                    y: Double(location.yToLatitude)!
                )
                return placeListCellModel
            }
            
            PageEndingCheck.shared.isend = model.meta.isEnd

            DispatchQueue.main.async {
                self?.placeList = placeList
                
                if placeList.count == 0 {
                    self?.viewController?.noResultData()
                } else {
                    self?.viewController?.reloadTableView()
                }
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
        
        if PageEndingCheck.shared.isend == true {
            return
        }
        let query = query
        let longitude = MyCoordinate.shared.longitudeString
        let latitude = MyCoordinate.shared.latitudeString
        
        KakaoMapAPIManager().kakaoMapKeywordSearch(
            query: query,
            longitude: longitude,
            latitude: latitude,
            page: "\(currentPage)"
        ) { [weak self] model in
            let placeList = model.documents.map { location in
                let placeListCellModel = PlaceListModel(
                    title: location.name,
                    distance: location.distance,
                    address: location.address,
                    phone: location.phone,
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
        let placeModel = AVIROCheckPlaceDTO(
            title: selectedItem.title,
            address: selectedItem.address,
            x: String(selectedItem.x),
            y: String(selectedItem.y)
        )
        
        AVIROAPIManager().getCheckPlace(placeModel: placeModel) { [weak self] checkedPlace in
            DispatchQueue.main.async {
                if checkedPlace.registered {
                    self?.viewController?.pushAlertController()
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
