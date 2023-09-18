//
//  EditPlaceInfoPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

import NMapsMap

protocol EditPlaceInfoProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    func setupBlurEffect()
    func setupGesture()
    func handleClosure()
    func whenViewWillAppearSelectedIndex(_ index: Int)
    func isDetailFieldCheckBeforeKeyboardShowAndHide(
        notification: NSNotification
    ) -> Bool
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func dataBindingLocation(
        title: String,
        category: String,
        marker: NMFMarker,
        address: String
    )
    func dataBindingPhone(phone: String)
    func dataBindingOperatingHours(
        operatingHourModels: [EditOperationHoursModel]
    )
    func dataBindingHomepage(homepage: String)
    func pushAddressEditViewController(
        placeMarkerModel: MarkerModel
    )
    func updateNaverMap(_ latLng: NMGLatLng)
    func editStoreButtonChangeableState(_ state: Bool)
    func popViewController()
}

final class EditPlaceInfoPresenter {
    weak var viewController: EditPlaceInfoProtocol?
    
    private var selectedIndex: Int!
    private var placeId: String?
    private var placeMarkerModel: MarkerModel?
    private var placeSummary: PlaceSummaryData?
    private var placeInfo: PlaceInfoData?
    private var placeOperationModels: [EditOperationHoursModel]?
    
    private var newMarker = NMFMarker()
    
    var afterChangedTitle = "" {
        didSet {
            checkIsChangedTitle()
        }
    }
    private var isChangedTitle = false {
        didSet {
            changeEditButtonState()
        }
    }
    
    var afterChangedCategory = Category.restaurant {
        didSet {
            checkIsChangedCategory()
        }
    }
    private var isChangedCategory = false {
        didSet {
            changeEditButtonState()
        }
    }
    
    var afterChangedAddress = "" {
        didSet {
            changedMarkerLocation()
            checkIsChangedAddress()
        }
    }
    private var isChangedAddress = false {
        didSet {
            changeEditButtonState()
        }
    }
    private var afterChangedXLng = ""
    private var afterChangedYLat = ""
    
    var afterChangedAddressDetail = "" {
        didSet {
            checkIsChangedAddressDetail()
        }
    }
    private var isChangedAddressDetail = false {
        didSet {
            changeEditButtonState()
        }
    }
    
    var afterChangedPhone = "" {
        didSet {
            checkIsChangedPhone()
        }
    }
    private var isChangedPhone = false {
        didSet {
            changeEditButtonState()
        }
    }
    
    private var afterChangedOperationHourArray = [EditOperationHoursModel]()
    var afterChangedOperationHour = EditOperationHoursModel(
        day: Day.mon,
        operatingHours: "",
        breakTime: "",
        isToday: false
    ) {
        didSet {
            checkIsChangedOperationHour()
        }
    }
    private var isChangedOperationHour = false {
        didSet {
            changeEditButtonState()
        }
    }
    
    var afterChangedURL = "" {
        didSet {
            checkIsChangedURL()
        }
    }
    private var isChangedURL = false {
        didSet {
            changeEditButtonState()
        }
    }
    
    init(viewController: EditPlaceInfoProtocol,
         placeMarkerModel: MarkerModel? = nil,
         placeId: String? = nil,
         placeSummary: PlaceSummaryData? = nil,
         placeInfo: PlaceInfoData? = nil,
         selectedIndex: Int = 0
    ) {
        self.viewController = viewController
        self.selectedIndex = selectedIndex
        self.placeMarkerModel = placeMarkerModel
        self.placeId = placeId
        self.placeSummary = placeSummary
        self.placeInfo = placeInfo
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupAttribute()
        viewController?.setupBlurEffect()
        viewController?.setupGesture()
        viewController?.handleClosure()
        
        dataBinding()
    }
    
    func viewWillAppear() {
        viewController?.whenViewWillAppearSelectedIndex(selectedIndex)

        addKeyboardNotification()
    }
    
    func viewWillDisappear() {
        removeKeyboardNotification()
    }
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(
        notification: NSNotification
    ) {
        guard let viewController = viewController else { return }
        
        if viewController.isDetailFieldCheckBeforeKeyboardShowAndHide(
            notification: notification
        ) {
            if let keyboardFrame: NSValue = notification.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey
            ] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
                viewController.keyboardWillShow(
                    height: keyboardRectangle.height
                )
            }
        }
    }
    
    @objc private func keyboardWillHide(
        notification: NSNotification) {
        guard let viewController = viewController else { return }
        
        if viewController.isDetailFieldCheckBeforeKeyboardShowAndHide(
            notification: notification
        ) {
            viewController.keyboardWillHide()
        }
    }
    
    // MARK: Data Binding
    private func dataBinding() {
        dataBindingLocation()
        dataBindingPhone()
        dataBindingWorkingHours()
        dataBindingHomepage()
    }
    
    private func dataBindingLocation() {
        guard let placeSummary = placeSummary,
              let placeMarkerModel = placeMarkerModel else { return }
        
        let title = placeSummary.title
        let category = placeSummary.category
        let address = placeSummary.address
        
        let markerPosition = placeMarkerModel.marker.position
        let markerImage = placeMarkerModel.marker.iconImage
        
        newMarker.position = markerPosition
        newMarker.iconImage = markerImage
        
        viewController?.dataBindingLocation(
            title: title,
            category: category,
            marker: newMarker,
            address: address
        )
    }
    
    private func dataBindingPhone() {
        guard let placeInfo = placeInfo,
              let phone = placeInfo.phone
        else { return }
        
        viewController?.dataBindingPhone(phone: phone)
    }
    
    private func dataBindingWorkingHours() {
        guard let placeId = placeId else { return }
        
        self.placeOperationModels = [EditOperationHoursModel]()
        
        AVIROAPIManager().getOperationHour(placeId: placeId
        ) { [weak self] model in
            DispatchQueue.main.async {
                let modelArray = model.data.toEditOperationHoursModels()
                
                self?.viewController?.dataBindingOperatingHours(
                    operatingHourModels: modelArray
                )
                
                self?.placeOperationModels = modelArray
            }
        }
    }
    
    private func dataBindingHomepage() {
        guard let placeInfo = placeInfo,
              let homepage = placeInfo.url
        else { return }
        
        viewController?.dataBindingHomepage(homepage: homepage)
    }
    
    func pushAddressEditViewController() {
        guard let placeMarkerModel = placeMarkerModel else { return }
        
        viewController?.pushAddressEditViewController(
            placeMarkerModel: placeMarkerModel
        )
    }

    private func changedMarkerLocation() {
        KakaoMapRequestManager().kakaoMapAddressSearch(
            address: afterChangedAddress
        ) { [weak self] addressModel in
            guard let documents = addressModel.documents, documents.count > 0 else { return }
            
            let firstCoordinate = documents[0]
            
            if let x = firstCoordinate.x, let y = firstCoordinate.y {
                DispatchQueue.main.async {
                    
                    self?.afterChangedXLng = x
                    self?.afterChangedYLat = y
                    
                    self?.changedMarker(lat: y, lng: x)
                }
            }
        }
    }
    
    private func changedMarker(
        lat: String,
        lng: String
    ) {
        guard let lat = Double(lat),
              let lng = Double(lng) else { return }
        
        let latLng = NMGLatLng(lat: lat, lng: lng)
        
        newMarker.position = latLng
        
        viewController?.updateNaverMap(latLng)
    }
}

// MARK: Data State Management Method
extension EditPlaceInfoPresenter {
    private func changeEditButtonState() {
        if isChangedTitle
            ||
            isChangedCategory
            ||
            isChangedAddress
            ||
            isChangedAddressDetail
            ||
            isChangedPhone
            ||
            isChangedOperationHour
            ||
            isChangedURL {
            viewController?.editStoreButtonChangeableState(true)
        } else {
            viewController?.editStoreButtonChangeableState(false)
        }
    }
    
    private func checkIsChangedTitle() {
        if afterChangedTitle != placeSummary?.title {
            isChangedTitle = true
        } else {
            isChangedTitle = false
        }
    }
    
    private func checkIsChangedCategory() {
        if afterChangedCategory.title != placeSummary?.category {
            isChangedCategory = true
        } else {
            isChangedCategory = false
        }
    }
    
    private func checkIsChangedAddress() {
        if afterChangedAddress != placeInfo?.address {
            isChangedAddress = true
        } else {
            isChangedCategory = false
        }
    }
    
    private func checkIsChangedAddressDetail() {
        if afterChangedAddressDetail != placeInfo?.address2 ?? "" {
            isChangedAddressDetail = true
        } else {
            isChangedAddressDetail = false
        }
        
    }
    
    private func checkIsChangedPhone() {
        if afterChangedPhone != placeInfo?.phone ?? "" {
            isChangedPhone = true
        } else {
            isChangedPhone = false
        }
    }
    
    private func checkIsChangedOperationHour() {
        placeOperationModels?.forEach {
            if $0.day == afterChangedOperationHour.day {
                if $0.breakTime != afterChangedOperationHour.breakTime
                    ||
                    $0.operatingHours != afterChangedOperationHour.operatingHours {
                    appendToOperationArrayWhenChangedOperationHour(
                        afterChangedOperationHour
                    )
                } else {
                    compareToAfterOperationArrayFromBeforeOperationArray(
                        afterChangedOperationHour
                    )
                }
            }
        }
    }
    
    private func appendToOperationArrayWhenChangedOperationHour(
        _ model: EditOperationHoursModel
    ) {
        if let index = afterChangedOperationHourArray
            .firstIndex(where: {$0.day == model.day}
        ) {
            afterChangedOperationHourArray[index]
                .operatingHours = model.operatingHours
            afterChangedOperationHourArray[index]
                .breakTime = model.breakTime
        } else {
            afterChangedOperationHourArray.append(model)
        }
        
        isChangedOperationHour = true
    }
    
    private func compareToAfterOperationArrayFromBeforeOperationArray(
        _ model: EditOperationHoursModel
    ) {
        if let index = afterChangedOperationHourArray
            .firstIndex(where: {$0.day == model.day}
        ) {
            afterChangedOperationHourArray
                .remove(at: index)
        }
        
        if afterChangedOperationHourArray.count == 0 {
            isChangedOperationHour = false
        } else {
            isChangedOperationHour = true
        }
    }
    
    private func checkIsChangedURL() {
        if afterChangedURL != placeInfo?.url ?? "" {
            isChangedURL = true
        } else {
            isChangedURL = false
        }
    }
}

// MARK: Data Edit Request Method
extension EditPlaceInfoPresenter {
    func afterEditButtonTapped() {
        guard let placeId = placeId,
              let placeTitle = placeSummary?.title
        else { return }
        
        let userId = UserId.shared.userId
        let nickName = UserId.shared.userNickname
        
        let dispatchGroup = DispatchGroup()
        
        requestEditLocation(
            placeId: placeId,
            placeTitle: placeTitle,
            userId: userId,
            nickName: nickName,
            dispatchGroup: dispatchGroup
        )
        
        requestEditPhone(
            placeId: placeId,
            placeTitle: placeTitle,
            userId: userId,
            nickName: nickName,
            dispatchGroup: dispatchGroup
        )

        requestEditOperationHour(
            placeId: placeId,
            userId: userId,
            dispatchGroup: dispatchGroup
        )
        
        requestEditURL(
            placeId: placeId,
            placeTitle: placeTitle,
            userId: userId,
            nickName: nickName,
            dispatchGroup: dispatchGroup
        )
        
        dispatchGroup.notify(queue: .main
        ) { [weak self] in
            self?.viewController?.popViewController()
        }
    }
    
    private func requestEditLocation(
        placeId: String,
        placeTitle: String,
        userId: String,
        nickName: String,
        dispatchGroup: DispatchGroup
    ) {
        if isChangedTitle
            ||
            isChangedCategory
            ||
            isChangedAddress
            ||
            isChangedAddressDetail {
            guard  let beforeCategory = placeSummary?.category,
                  let beforeAddress = placeInfo?.address
            else { return }
            
            let beforeAdderss2 = placeInfo?.address2 ?? ""
            
            dispatchGroup.enter()
            
            let model = AVIROEditLocationDTO(
                placeId: placeId,
                userId: userId,
                nickname: nickName,
                title: placeTitle,
                changedTitle: isChangedTitle ?
                    AVIROEditCommonBeforeAfterDTO(
                        before: placeTitle,
                        after: afterChangedTitle
                    )
                :
                    nil,
                category: isChangedCategory ?
                    AVIROEditCommonBeforeAfterDTO(
                        before: beforeCategory,
                        after: afterChangedCategory.title
                    )
                :
                    nil,
                address: whenRequestAndLoadAddressBasedOnCondition(
                    beforeAddress: beforeAddress
                ),
                address2: whenRequestAndLoadDetailAddressBasedOnCondition(
                    beforeDetailAddress: beforeAdderss2
                ),
                x: whenRequestAndLoadXLongitude(beforeAddress: beforeAddress),
                y: whenRequestAndLoadYLatitude(beforeAddress: beforeAddress)
            )
            
            AVIROAPIManager().postEditPlaceLocation(model
            ) { resultModel in
                print(resultModel.statusCode)
                print(resultModel.message ?? "")

                dispatchGroup.leave()
            }
        }
    }
    
    private func whenRequestAndLoadAddressBasedOnCondition(
        beforeAddress: String
    ) -> AVIROEditCommonBeforeAfterDTO? {
        if (isChangedAddress || isChangedAddressDetail)
            &&
            (afterChangedAddress != "" && afterChangedAddress != beforeAddress) {
            return AVIROEditCommonBeforeAfterDTO(
                before: beforeAddress,
                after: afterChangedAddress
            )
        } else if
            (isChangedAddress || isChangedAddressDetail)
                &&
            (afterChangedAddress == "" || afterChangedAddress == beforeAddress) {
            return AVIROEditCommonBeforeAfterDTO(
                before: beforeAddress,
                after: beforeAddress
            )
        } else {
            return nil
        }
    }
    
    private func whenRequestAndLoadDetailAddressBasedOnCondition(
        beforeDetailAddress: String
    ) -> AVIROEditCommonBeforeAfterDTO? {
        if (isChangedAddress || isChangedAddressDetail)
            &&
            (afterChangedAddressDetail != ""
             &&
             afterChangedAddressDetail != beforeDetailAddress
            ) {
            return AVIROEditCommonBeforeAfterDTO(
                before: beforeDetailAddress,
                after: afterChangedAddressDetail
            )
        } else if
            (isChangedAddress || isChangedAddressDetail)
                &&
            (afterChangedAddressDetail == ""
             ||
             afterChangedAddressDetail == beforeDetailAddress
            ) {
            return AVIROEditCommonBeforeAfterDTO(
                before: beforeDetailAddress,
                after: beforeDetailAddress
            )
        } else {
            return nil
        }
    }
    
    private func whenRequestAndLoadXLongitude(
        beforeAddress: String
    ) -> AVIROEditCommonBeforeAfterDTO? {
        let beforeX = String(placeMarkerModel?.marker.position.lng ?? 0.0)
        
        if isChangedAddress {
            return AVIROEditCommonBeforeAfterDTO(before: beforeX, after: afterChangedXLng)
        } else if isChangedAddressDetail {
            return AVIROEditCommonBeforeAfterDTO(before: beforeX, after: beforeX)
        } else {
            return nil
        }
    }
    
    private func whenRequestAndLoadYLatitude(
        beforeAddress: String
    ) -> AVIROEditCommonBeforeAfterDTO? {
        let beforeY = String(placeMarkerModel?.marker.position.lat ?? 0.0)
        
        if isChangedAddress {
            return AVIROEditCommonBeforeAfterDTO(before: beforeY, after: afterChangedYLat)
        } else if isChangedAddressDetail {
            return AVIROEditCommonBeforeAfterDTO(before: beforeY, after: afterChangedYLat)
        } else {
            return nil
        }
    }
    
    private func requestEditPhone(
        placeId: String,
        placeTitle: String,
        userId: String,
        nickName: String,
        dispatchGroup: DispatchGroup
    ) {
        if isChangedPhone {

            dispatchGroup.enter()

            let beforePhone = placeInfo?.phone ?? ""
            
            let model = AVIROEditPhoneDTO(
                placeId: placeId,
                userId: userId,
                nickname: nickName,
                title: placeTitle,
                phone: AVIROEditCommonBeforeAfterDTO(
                    before: beforePhone,
                    after: afterChangedPhone
                )
            )
            
            AVIROAPIManager().postEditPlacePhone(model
            ) { resultModel in
                print(resultModel.statusCode)
                print(resultModel.message ?? "")
                
                dispatchGroup.leave()
            }
        }
    }
    
    private func requestEditOperationHour(
        placeId: String,
        userId: String,
        dispatchGroup: DispatchGroup
    ) {
        if isChangedOperationHour {
            
            dispatchGroup.enter()
            
            var mon: EditOperationHoursModel?
            var tue: EditOperationHoursModel?
            var wed: EditOperationHoursModel?
            var thu: EditOperationHoursModel?
            var fri: EditOperationHoursModel?
            var sat: EditOperationHoursModel?
            var sun: EditOperationHoursModel?
            
            afterChangedOperationHourArray.forEach {
                switch $0.day {
                case .mon:
                    mon = EditOperationHoursModel(
                        day: $0.day,
                        operatingHours: $0.operatingHours,
                        breakTime: $0.breakTime,
                        isToday: $0.isToday
                    )
                case .tue:
                    tue = EditOperationHoursModel(
                        day: $0.day,
                        operatingHours: $0.operatingHours,
                        breakTime: $0.breakTime,
                        isToday: $0.isToday
                    )
                case .wed:
                    wed = EditOperationHoursModel(
                        day: $0.day,
                        operatingHours: $0.operatingHours,
                        breakTime: $0.breakTime,
                        isToday: $0.isToday
                    )
                case .thu:
                    thu = EditOperationHoursModel(
                        day: $0.day,
                        operatingHours: $0.operatingHours,
                        breakTime: $0.breakTime,
                        isToday: $0.isToday
                    )
                case .fri:
                    fri = EditOperationHoursModel(
                        day: $0.day,
                        operatingHours: $0.operatingHours,
                        breakTime: $0.breakTime,
                        isToday: $0.isToday
                    )
                case .sat:
                    sat = EditOperationHoursModel(
                        day: $0.day,
                        operatingHours: $0.operatingHours,
                        breakTime: $0.breakTime,
                        isToday: $0.isToday
                    )
                case .sun:
                    sun = EditOperationHoursModel(
                        day: $0.day,
                        operatingHours: $0.operatingHours,
                        breakTime: $0.breakTime,
                        isToday: $0.isToday
                    )
                }
            }
            
            let model = AVIROEditOperationTimeDTO(
                placeId: placeId,
                userId: userId,
                mon: mon?.operatingHours,
                monBreak: mon?.breakTime,
                tue: tue?.operatingHours,
                tueBreak: tue?.breakTime,
                wed: wed?.operatingHours,
                wedBreak: wed?.breakTime,
                thu: thu?.operatingHours,
                thuBreak: thu?.breakTime,
                fri: fri?.operatingHours,
                friBreak: fri?.breakTime,
                sat: sat?.operatingHours,
                satBreak: sat?.breakTime,
                sun: sun?.operatingHours,
                sunBreak: sun?.breakTime
            )
            
            print(model)
                        
            AVIROAPIManager().postEditPlaceOperation(model
            ) { resultModel in
                print(resultModel.statusCode)
                print(resultModel.message ?? "")
                
                dispatchGroup.leave()
            }
        }
    }
    
    private func requestEditURL(
        placeId: String,
        placeTitle: String,
        userId: String,
        nickName: String,
        dispatchGroup: DispatchGroup
    ) {
        if isChangedURL {
            dispatchGroup.enter()
            
            let beforeURL = placeInfo?.url ?? ""
            
            let model = AVIROEditURLDTO(
                placeId: placeId,
                userId: userId,
                nickname: nickName,
                title: placeTitle,
                url: AVIROEditCommonBeforeAfterDTO(
                    before: beforeURL,
                    after: afterChangedURL
                )
            )
            
            AVIROAPIManager().postEditPlaceURL(model
            ) { resultModel in
                print(resultModel.statusCode)
                print(resultModel.message ?? "")
                
                dispatchGroup.leave()
            }
        }
    }
}
