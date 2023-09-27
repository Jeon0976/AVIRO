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
    func showErrorAlert(with error: String, title: String?)
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
        if isLoading {
            return
        }
        
        isLoading = true
        currentPage = 1
        
        let query = query
        let longitude = MyCoordinate.shared.longitudeString
        let latitude = MyCoordinate.shared.latitudeString
        
        let model = KakaoKeywordSearchDTO(
            query: query,
            lng: longitude,
            lat: latitude,
            page: "\(currentPage)",
            isAccuracy: nil
        )
        
        KakaoAPIManager().keywordSearchPlace(with: model) { [weak self] result in
            switch result {
            case .success(let listModel):
                let placeList = listModel.documents.map { location in
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
                
                self?.isEnd = listModel.meta.isEnd
                
                if placeList.count == 0 {
                    self?.viewController?.noResultData()
                } else {
                    self?.placeList = placeList
                    self?.viewController?.reloadTableView()
                }
                
                self?.isLoading = false

            case .failure(let error):
                self?.isLoading = false
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    // MARK: 스크롤 할 때 데이터 load 함수
    func loadData(_ query: String) {
        // loding 일 때 api 호출 x
        if isLoading || isEnd {
            return
        }
        
        isLoading = true
        currentPage += 1
        
        let query = query
        let longitude = MyCoordinate.shared.longitudeString
        let latitude = MyCoordinate.shared.latitudeString
        
        let model = KakaoKeywordSearchDTO(
            query: query,
            lng: longitude,
            lat: latitude,
            page: "\(currentPage)",
            isAccuracy: nil
        )
        
        KakaoAPIManager().keywordSearchPlace(with: model) { [weak self] result in
            switch result {
            case .success(let listModel):
                let placeList = listModel.documents.map { location in
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
                
                self?.isEnd = listModel.meta.isEnd
                self?.isLoading = false
                self?.placeList.append(contentsOf: placeList)
                self?.viewController?.reloadTableView()
                
            case .failure(let error):
                self?.isLoading = false
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
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
        
        AVIROAPIManager().checkPlaceOne(with: placeModel) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if success.registered {
                        self?.viewController?.pushAlertController()
                    } else {
                        self?.savePlaceModel(selectedItem)
                        self?.viewController?.popViewController()
                    }
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    // MARK: Place Model 저장
    func savePlaceModel(_ selectedPlace: PlaceListModel) {
        DispatchQueue.main.async {
            let userInfo: [String: Any] = ["selectedPlace": selectedPlace]
            
            NotificationCenter.default.post(
                name: NSNotification.Name("selectedPlace"),
                object: nil,
                userInfo: userInfo
            )
        }
    }
}
