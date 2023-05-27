//
//  PlaceListViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

protocol PlaceListProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func reloadTableView()
}

final class PlaceListViewPresenter: NSObject {
    weak var viewController: PlaceListProtocol?
    
    private let requestManager = KakaoMapRequestManager()
    
    var placeList = [PlaceListModel]()
    
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
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
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
                    category: location.category,
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
                    category: location.category,
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
        
        let userInfo: [String: Any] = ["selectedPlace": selectedItem]
        
        NotificationCenter.default.post(
            name: NSNotification.Name("selectedPlace"),
            object: nil,
            userInfo: userInfo
        )
    }
}

// MARK: TableView DataSource
extension PlaceListViewPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceListCell.identifier,
            for: indexPath
        ) as? PlaceListCell
        
        let title = placeList[indexPath.row].title
        let category = placeList[indexPath.row].category
        let address = placeList[indexPath.row].address
        let distance = placeList[indexPath.row].distance
        
        let cellData = PlaceListCellModel(
            title: title,
            category: category,
            address: address,
            distance: distance
        )
        
        cell?.makeCellData(cellData)
        
        cell?.backgroundColor = .white
        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }
}
